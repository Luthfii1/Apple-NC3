//
//  CreatePlanView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI

struct CreateEditPlanView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var createPlanVM: CreateEditPlanViewModel
    @StateObject private var searchPlaceViewModel = SearchPlaceViewModel()
    var isCreate: Bool
    var idPlan: UUID?
    @State private var discardChanges: Bool = false

    var body: some View {
        NavigationView {
            Form {
                titleLocationSection
                durationSection
                eventSection
                reminderSection
                if !isCreate { deleteSection }
            }
            .alert(isPresented: $createPlanVM.state.showDeleteAlert) {
                Alert(
                    title: Text("Are you sure you want to delete your plan?"),
                    primaryButton: .destructive(Text("Delete")) {
                        Task {
                            await homeViewModel.deletePlan(planId: createPlanVM.newPlan.id)
                        }
                        dismissView()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationBarTitle(isCreate ? "New Plan" : "Edit Plan", displayMode: .inline)
            .navigationBarItems(
                leading: cancelButton,
                trailing: doneButton
            )
        }
        .onAppear {
            if !isCreate, let idPlan = idPlan {
                Task {
                    await createPlanVM.getDetailPlan(planId: idPlan)
                }
            }
        }
        .confirmationDialog(
            "Are you sure you want to discard your changes?",
            isPresented: $discardChanges
        ) {
            Button("Discard Changes", role: .destructive) {
                dismissView()
            }
            Button("Cancel", role: .cancel) {}
        }
        message: {
            Text("Are you sure you want to discard your changes?")
        }
    }

    private var titleLocationSection: some View {
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

    private var durationSection: some View {
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

    private var eventSection: some View {
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
                        get: { createPlanVM.newPlan.daysRepeat ?? Set() },
                        set: { createPlanVM.newPlan.daysRepeat = $0 }
                    )
                )
            }
        }
    }

    private var reminderSection: some View {
        Section {
            Picker("Reminder", selection: $createPlanVM.newPlan.reminder) {
                ForEach(REMINDER.allCases, id: \.self) { selection in
                    if selection == .None {
                        Text(selection.rawValue).tag(selection)
                        Divider()
                    } else {
                        Text(selection.rawValue).tag(selection)
                    }
                }
            }
        }
    }

    private var deleteSection: some View {
        Section {
            Button("Delete Plan") {
                createPlanVM.state.showDeleteAlert = true
            }
            .foregroundColor(.red)
        }
    }

    private var cancelButton: some View {
        Button("Cancel") {
            if isCreate {
                if createPlanVM.cancelAction() {
                    discardChanges = true
                } else {
                    dismissView()
                }
            } else {
                if createPlanVM.cancelEditChanges() {
                    discardChanges = true
                } else {
                    dismissView()
                }
            }
            homeViewModel.resetSwipeOffsetFlag()
        }
    }

    private var doneButton: some View {
        Button("Done") {
            Task {
                isCreate ? await createPlanVM.insertPlan(homeViewModel: homeViewModel) : await createPlanVM.updatePlan(homeViewModel: homeViewModel)
            }
            dismissView()
            NotificationManager.shared.scheduleNotifications()
            homeViewModel.resetSwipeOffsetFlag()
        }
        .disabled(!createPlanVM.isFormValid)
        .bold(!createPlanVM.isFormValid ? false : true)
    }

    private func dismissView() {
        if isCreate {
            homeViewModel.state.isCreateSheetPresented = false
        } else {
            homeViewModel.state.isEditSheetPresented = false
        }
    }
}

#Preview {
    CreateEditPlanView(isCreate: true)
}
