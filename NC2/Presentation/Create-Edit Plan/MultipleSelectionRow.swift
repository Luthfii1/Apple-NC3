//
//  MultipleSelectionRow.swift
//  NC2
//
//  Created by Felicia Himawan on 15/07/24.
//

import SwiftUI

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.default)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
