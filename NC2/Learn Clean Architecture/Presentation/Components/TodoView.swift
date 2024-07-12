//
//  TodoView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 11/07/24.
//

import SwiftUI

struct TodoView: View {
    var desc: String
    var isCompleted: Bool
    
    var body: some View {
        HStack {
            Text(desc)
            Spacer()
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "x.circle.fill")
                .foregroundStyle(isCompleted ? .green : .red)
        }
//        .padding()
//        .background(.gray.opacity(0.5))
//        .clipShape(RoundedRectangle(cornerRadius: 10))
//        .padding()
    }
}

#Preview {
    TodoView(desc: "Makan, mandi, shalat dzuhur", isCompleted: false)
}
