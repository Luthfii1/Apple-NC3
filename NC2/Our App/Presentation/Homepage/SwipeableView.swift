//
//  SwipeableView.swift
//  NC2
//
//  Created by Felicia Himawan on 17/07/24.
//

import SwiftUI


struct SwipeableView: View {
    let plan: PlanCardEntity
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    
    var body: some View {
        ZStack {
            HStack (spacing: 0){
                Spacer()
                Button(action: {
                    print("edit pressed")
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .padding(30)
                        .frame(width: 80, height: 104)
                        .background(Color.gray)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    print("delete pressed")
                }) {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .padding(27)
                        .frame(width: 74, height: 104)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .customCornerRadius(10, corners: [.topRight, .bottomRight])
                }
            }
            
            PlanCardComponent(plan: plan)
                .offset(x: offset)
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { gesture in
                            if isSwiped {
                                if gesture.translation.width > 0 {
                                    self.offset = min(gesture.translation.width - 145, 0)
                                }
                            } else {
                                if gesture.translation.width < 0 {
                                    self.offset = max(gesture.translation.width, -145)
                                    print(gesture.translation.width)
                                }
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                if isSwiped {
                                    if self.offset > -70 {
                                        self.offset = 0
                                        self.isSwiped = false
                                    } else {
                                        self.offset = -145
                                    }
                                } else {
                                    if -self.offset > 70 {
                                        self.offset = -145
                                        self.isSwiped = true
                                    } else {
                                        self.offset = 0
                                    }
                                }
                            }
                        }
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


