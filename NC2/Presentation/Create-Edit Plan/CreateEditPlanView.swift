//
//  CreatePlanView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//
import SwiftUI
import MapKit
import SwiftData
import WidgetKit

struct CreateEditPlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var createPlanVM: CreateEditPlanViewModel
    @StateObject private var searchPlaceViewModel = SearchPlaceViewModel()
    var isCreate: Bool
    var idPlan: UUID?
    
    var body: some View {
        NavigationView {
            Form {
                planDetailsSection
                planTimeSection
                planCategorySection
                routineSection
                reminderSection
                deleteSection
            }
            .alert(isPresented: $createPlanVM.state.showDeleteAlert) {
                deleteAlert
            }
            .navigationBarTitle(isCreate ? "New Plan" : "Edit Plan", displayMode: .inline)
            .fontDesign(.rounded)
            .navigationBarItems(
                leading: cancelButton,
                trailing: doneButton
            )
            .onAppear {
                if !isCreate {
                    Task {
                        await createPlanVM.getDetailPlan(planId: idPlan!)
                    }
                }
            }
            .confirmationDialog(
                String(localized: "Are you sure you want to discard your changes?"),
                isPresented: $createPlanVM.state.showDiscardChangesDialog,
                titleVisibility: .visible
            ) {
                discardChangesDialog
            }
        }
    }
    
    private var planDetailsSection: some View {
        Section {
            TextField("Title", text: $createPlanVM.newPlan.title)
            Button(action: {
                searchPlaceViewModel.isSheetPresented = true
            }) {
                TextField("Location", text: $createPlanVM.newPlan.location.nameLocation)
                    .disabled(true)
            }
            .foregroundStyle(Color.primary)
            .sheet(isPresented: $searchPlaceViewModel.isSheetPresented) {
                SearchPlace(viewModel: searchPlaceViewModel)
                    .onAppear {
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
    }
    
    private var planTimeSection: some View {
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
    }
    
    private var planCategorySection: some View {
            Section {
                Picker("Event", selection: $createPlanVM.newPlan.planCategory) {
                    ForEach(PLANCATEGORY.allCases, id: \.self) { selection in
                        Text(selection.localizedString()).tag(selection)
                    }
                }
            }
            
//            if createPlanVM.newPlan.planCategory == .Routine {
//                Section {
//                    MultiSelectPicker(
//                        title: String(localized: "Repeat"),
//                        options: DAYS.allCases,
//                        selections: Binding(
//                            get: {
//                                createPlanVM.newPlan.daysRepeat ?? Set()
//                            },
//                            set: {
//                                createPlanVM.newPlan.daysRepeat = $0
//                            }
//                        )
//                    )
//                }
//            }
        
    }
    
    private var routineSection: some View {
        Section {
            MultiSelectPicker(
                title: String(localized: "Repeat"),
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
    
    private var reminderSection: some View {
        Section {
            Picker("Reminder", selection: $createPlanVM.newPlan.reminder) {
                ForEach(REMINDER.allCases, id: \.self) { selection in
                    if selection == .None {
                        Text(selection.localizedString()).tag(selection)
                        Divider()
                    } else {
                        Text(selection.localizedString()).tag(selection)
                    }
                }
            }
        }
    }
    
    private var deleteSection: some View {
        Group {
            if !isCreate {
                Section {
                    Button("Delete Plan") {
                        createPlanVM.state.showDeleteAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private var deleteAlert: Alert {
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
    
    private var cancelButton: some View {
        Button("Cancel") {
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
            homeViewModel.resetSwipeOffsetFlag()
        }
    }
    
    private var doneButton: some View {
        Button("Done") {
            Task {
                if isCreate {
                    await createPlanVM.insertPlan(homeViewModel: homeViewModel)
                } else {
                    await createPlanVM.updatePlan(homeViewModel: homeViewModel)
                }
            }
            presentationMode.wrappedValue.dismiss()
            NotificationManager.shared.scheduleNotifications()
        }
        .disabled(!createPlanVM.isFormValid)
        .bold(!createPlanVM.isFormValid ? false : true)
    }
    
    private var discardChangesDialog: some View {
        VStack {
            Button(String(localized: "Discard Changes"), role: .destructive) {
                createPlanVM.resetNewPlanToComparePlan()
                presentationMode.wrappedValue.dismiss()
            }
            Button(String(localized: "Cancel"), role: .cancel) {}
        }
    }
}

//#Preview {
//    CreateEditPlanView(isCreate: true)
//}
