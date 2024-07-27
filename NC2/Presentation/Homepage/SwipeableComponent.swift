//
//  SwipeableView.swift
//  NC2
//
//  Created by Felicia Himawan on 17/07/24.
//

import SwiftUI

struct SwipeableComponent: View {
    @EnvironmentObject var vm: HomeViewModel
    let plan: HomeCardUIModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Buttons for Edit and Delete
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
                    Task {
                        await vm.deletePlan(planId: plan.id)
                    }
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
            
            // Plan Card
            PlanCardComponent(plan: plan)
                .offset(x: vm.offset)
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { gesture in
                            if vm.isSwiped {
                                if gesture.translation.width > 0 {
                                    vm.offset = min(gesture.translation.width - 160, 0)
                                }
                            } else {
                                if gesture.translation.width < 0 {
                                    vm.offset = max(gesture.translation.width, -160)
                                }
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                if vm.isSwiped {
                                    if vm.offset > -70 {
                                        vm.offset = 0
                                        vm.isSwiped = false
                                    } else {
                                        vm.offset = -160
                                    }
                                } else {
                                    if -vm.offset > 70 {
                                        vm.offset = -160
                                        vm.isSwiped = true
                                    } else {
                                        vm.offset = 0
                                    }
                                }
                            }
                        }
                )
                .onChange(of: vm.state.resetSwipeOffset, {
                    if vm.state.resetSwipeOffset {
                        withAnimation {
                            vm.offset = 0
                            vm.isSwiped = false
                        }
                    }
                })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
