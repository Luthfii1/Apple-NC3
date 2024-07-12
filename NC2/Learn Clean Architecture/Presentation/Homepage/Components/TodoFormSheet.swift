//
//  TodoFormSheet.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 11/07/24.
//

import SwiftUI

struct TodoFormSheet: View {
    @EnvironmentObject var vm: HomepageViewModel
    @Binding var isCreated: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form{
            Section{
                TextField("Description", text: $vm.textTodo)
            }
            
            Button(action: {
                Task {
                    await vm.insertTodo()
                }
                isCreated = false
                dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
        }
    }
}

//#Preview {
//    FormSheet()
//}
