//
//  ButtonComponent.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI

struct ButtonComponent: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50, alignment: .bottomTrailing)
                .foregroundStyle(.yellow)
        })
        .padding()
    }
}

#Preview {
    ButtonComponent(action: {print("Hallo")})
}
