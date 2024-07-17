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
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $createPlanVM.newPlan.title)
                    TextField("Location", text: $createPlanVM.newPlan.location.nameLocation)
                        .onTapGesture {
                            searchPlaceViewModel.isSheetPresented = true
                        }
                        .sheet(isPresented: $searchPlaceViewModel.isSheetPresented) {
                            SearchPlace(viewModel: searchPlaceViewModel)
                                .onAppear{
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
                        in: createPlanVM.newPlan.durationPlan.start...createPlanVM.dateRange.upperBound,
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
            }
            .navigationBarTitle("New Plan", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    if createPlanVM.cancelAction() {
                        createPlanVM.state.showDiscardChangesDialog = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: Button("Done") {
                    Task {
                        await createPlanVM.insertPlan(homeViewModel: homeViewModel)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                    .disabled(!createPlanVM.isFormValid)
                    .bold(!createPlanVM.isFormValid ? false : true)
            )
        }
        .confirmationDialog("Are you sure you want to discard your changes?", isPresented: $createPlanVM.state.showDiscardChangesDialog) {
            Button("Discard Changes", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    CreatePlanView()
}



