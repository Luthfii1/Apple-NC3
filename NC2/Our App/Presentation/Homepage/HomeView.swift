//
//  HomeView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var isCreateSheetPresented = false
    @State private var isEditSheetPresented = false
    @Environment(\.modelContext) private var context: ModelContext
    
    @Query var plans: [PlanModel]
    @State private var selectedPlan: PlanModel?
    
    var body: some View {
        VStack{
            Text("Hello, This is Home View")
            
            List(plans) { plan in
                VStack(alignment: .leading) {
                    Text(plan.title)
                        .font(.headline)
                    Text(plan.location)
                        .font(.subheadline)
                    Text("Latitude: \(plan.latitude)")
                        .font(.subheadline)
                    Text("Longitude: \(plan.longitude)")
                        .font(.subheadline)
                }
                .contextMenu {
                    Button(action: {
                        selectedPlan = plan
                        isEditSheetPresented = true
                    }) {
                        Text("Edit")
                    }
                }
            }
            
            Button(action: {
                isCreateSheetPresented = true
            }) {
                Text("Create Plan")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $isCreateSheetPresented) {
            CreatePlanView()
                .onAppear{
                    setWindowBackgroundColor(.black)
                }
        }
        .sheet(isPresented: $isEditSheetPresented) {
            if let planToEdit = selectedPlan {
                EditPlanView(viewModel: EditPlanViewModel(plan: planToEdit))
                    .onAppear{
                        setWindowBackgroundColor(.black)
                    }
            }
        }
    }
}

private func setWindowBackgroundColor(_ color: UIColor) {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first
    {
        window.backgroundColor = color
    }
}

#Preview {
    HomeView()
}
