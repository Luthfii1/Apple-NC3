//
//  EditPlanView.swift
//  NC2
//
//  Created by Felicia Himawan on 14/07/24.
//
import SwiftUI
import SwiftData
import MapKit

struct EditPlanView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: EditPlanViewModel
    @StateObject private var searchPlaceViewModel = SearchPlaceViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $viewModel.title)
                    TextField("Location", text: $viewModel.location)
                        .onTapGesture {
                            searchPlaceViewModel.isSheetPresented = true
                        }
                        .sheet(isPresented: $searchPlaceViewModel.isSheetPresented) {
                            SearchPlace(viewModel: searchPlaceViewModel)
                                .onAppear {
                                    viewModel.setWindowBackgroundColor(.black)
                                }
                                .onDisappear {
                                    if let selectedLocation = searchPlaceViewModel.selectedLocation {
                                        viewModel.location = selectedLocation.name ?? "Unknown"
                                        viewModel.latitude = selectedLocation.placemark.coordinate.latitude
                                        viewModel.longitude = selectedLocation.placemark.coordinate.longitude
                                    }
                                }
                        }
                }
                
                Section {
                    Toggle(isOn: $viewModel.allDay) {
                        Text("All-day")
                    }
                    
                    DatePicker(
                        "Starts",
                        selection: $viewModel.startDate,
                        in: viewModel.dateRange,
                        displayedComponents: viewModel.allDay ? [.date] : [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    
                    DatePicker(
                        "Ends",
                        selection: $viewModel.endDate,
                        in: viewModel.startDate...viewModel.dateRange.upperBound,
                        displayedComponents: viewModel.allDay ? [.date] : [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                }
                
                Section {
                    Picker("Event", selection: $viewModel.eventPicker) {
                        ForEach(viewModel.EventSelection, id: \.self) { selection in
                            Text(selection).tag(selection)
                        }
                    }
                }
                
                Section {
                    Picker("Reminder", selection: $viewModel.reminderPicker) {
                        ForEach(viewModel.ReminderSelection, id: \.self) { selection in
                            Text(selection).tag(selection)
                            if selection == "None" {
                                Divider() // Add a divider after the "None" option
                            }
                        }
                    }
                }
                
                Section {
                    Button("Delete Plan") {
                        viewModel.deletePlan(context: context)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarTitle("Edit Plan", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    if viewModel.cancelAction() {
                        viewModel.showDiscardChangesDialog = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: Button("Done") {
                    viewModel.saveChanges(context: context)
                    presentationMode.wrappedValue.dismiss()
                }
                    .disabled(!viewModel.isFormValid)
                    .bold(!viewModel.isFormValid ? false : true)
            )
        }
        .confirmationDialog("Are you sure you want to discard your changes?", isPresented: $viewModel.showDiscardChangesDialog) {
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
