//
//  CreatePlanView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI
import MapKit
import SwiftData

struct CreatePlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var createPlanVM: CreatePlanViewModel
    @StateObject private var searchPlaceViewModel = SearchPlaceViewModel()
    var isCreate: Bool
    var idPlan: UUID?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $createPlanVM.newPlan.title)
                    Button(action: {
                        searchPlaceViewModel.isSheetPresented = true
                    }, label: {
                        TextField("Location", text: $createPlanVM.newPlan.location.nameLocation)
                            .disabled(true)
                    })
                    .foregroundStyle(Color.primary)
                    .sheet(isPresented: $searchPlaceViewModel.isSheetPresented) {
                        SearchPlace(viewModel: searchPlaceViewModel)
                            .onAppear{
                                print("2")
                                createPlanVM.setWindowBackgroundColor(.black)
                            }
                            .onDisappear {
                                if let selectedLocation = searchPlaceViewModel.selectedLocation {
                                    createPlanVM.newPlan.location.nameLocation = selectedLocation.name ?? "Unknown"
                                    createPlanVM.newPlan.location.coordinatePlace.latitude = selectedLocation.placemark.coordinate.latitude
                                    createPlanVM.newPlan.location.coordinatePlace.longitude = selectedLocation.placemark.coordinate.longitude
                                    createPlanVM.newPlan.location.detailAddress = selectedLocation.placemark.locality ?? "No Locality"
                                }
                            }
                    }
                }
                
                Section {
                    Toggle(isOn: $createPlanVM.newPlan.allDay) {
                        Text("All-day")
                    }
                    
                    DatePicker(
                        "Starts",
                        selection: $createPlanVM.newPlan.durationPlan.start,
                        in: createPlanVM.dateRange,
                        displayedComponents: createPlanVM.newPlan.allDay ? [.date] : [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    
                    
                    DatePicker(
                        "Ends",
                        selection: $createPlanVM.newPlan.durationPlan.end,
                        in: createPlanVM.newPlan.durationPlan.start...Date.distantFuture,
                        displayedComponents: createPlanVM.newPlan.allDay ? [.date] : [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    
                    
                }
                
                Section {
                    Picker("Event", selection: $createPlanVM.newPlan.planCategory) {
                        ForEach(PLANCATEGORY.allCases, id: \.self) { selection in
                            Text(selection.rawValue).tag(selection)
                        }
                    }
                    
                    
                    if createPlanVM.newPlan.planCategory == .Routine {
                        MultiSelectPicker(
                            title: "Repeat",
                            options: DAYS.allCases,
                            selections: Binding(
                                get: {
                                    createPlanVM.newPlan.daysRepeat ?? Set()
                                },
                                set: {
                                    createPlanVM.newPlan.daysRepeat = $0
                                }
                            )
                        )
                    }
                }
                
                Section {
                    Picker("Reminder", selection: $createPlanVM.newPlan.reminder) {
                        ForEach(REMINDER.allCases, id: \.self) { selection in
                            if selection == .None {
                                Text(selection.rawValue)
                                    .tag(selection)
                                Divider()
                            } else {
                                Text(selection.rawValue).tag(selection)
                            }
                        }
                    }
                    
                }
                
                if !isCreate {
                    Section {
                        Button("Delete Plan") {
                            createPlanVM.state.showDeleteAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert(isPresented: $createPlanVM.state.showDeleteAlert) { // Add this block for the delete alert
                Alert(
                    title: Text("Are you sure you want to delete your plan?"),
                    primaryButton: .destructive(Text("Delete")) {
                        Task {
                            await homeViewModel.deletePlan(planId: createPlanVM.newPlan.id)
                        }
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationBarTitle("New Plan", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    if isCreate {
                        if createPlanVM.cancelAction() {
                            createPlanVM.state.showDiscardChangesDialog = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        if createPlanVM.cancelEditChanges() {
                            createPlanVM.state.showDiscardChangesDialog = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                },
                trailing: Button("Done") {
                    Task {
                        isCreate ?
                        await createPlanVM.insertPlan(homeViewModel: homeViewModel) :
                        await createPlanVM.updatePlan(homeViewModel: homeViewModel)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                    .disabled(!createPlanVM.isFormValid)
                    .bold(!createPlanVM.isFormValid ? false : true)
            )
        }
        .onAppear{
            if !isCreate {
                Task{
                    await createPlanVM.getDetailPlan(planId: idPlan!)
                }
            }
        }
        .confirmationDialog("Are you sure you want to discard your changes?", isPresented: $createPlanVM.state.showDiscardChangesDialog) {
            Button("Discard Changes", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
        message: {
            Text("Are you sure you want to discard your changes?")
        }
    }
}

#Preview {
    CreatePlanView(isCreate: true)
}



