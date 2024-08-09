//
//  SwipeableView.swift
//  NC2
//
//  Created by Felicia Himawan on 17/07/24.
//
import SwiftUI

struct SwipeableComponent: View {
    @EnvironmentObject var vm: HomeViewModel
    @State private var showAlert = false
    @State private var offset: CGFloat = 0
    let plan: HomeCardUIModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                Spacer()
                Button(action: {
                    vm.state.isEditSheetPresented = true
                    vm.idPlanEdit = plan.id
                }) {
                    ZStack {
                        Color.gray
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    .frame(width: 90, height: 120)
                }
                
                Button(action: {
                    showAlert = true
                }) {
                    ZStack {
                        Color.red
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80, height: 120)
                    .customCornerRadius(10, corners: [.topRight, .bottomRight])
                }
            }
            
            PlanCardComponent(plan: plan)
                .offset(x: offset)
                .onChange(of: vm.isSwiped, {
                    if !vm.isSwiped {
                        self.offset = 0
                    }
                })
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { gesture in
                            if vm.isSwiped {
                                if gesture.translation.width > 0 {
                                    offset = min(gesture.translation.width - 160, 0)
                                }
                            } else {
                                if gesture.translation.width < 0 {
                                    offset = max(gesture.translation.width, -160)
                                }
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                if vm.isSwiped {
                                    if offset > -70 {
                                        offset = 0
                                        vm.isSwiped = false
                                    } else {
                                        offset = -160
                                    }
                                } else {
                                    if -offset > 70 {
                                        offset = -160
                                        vm.isSwiped = true
                                    } else {
                                        offset = 0
                                    }
                                }
                            }
                        }
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure you want to delete your plan?"),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        await vm.deletePlan(planId: plan.id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}
