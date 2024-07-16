//
//  MultiSelectPicker.swift
//  NC2
//
//  Created by Felicia Himawan on 15/07/24.
//

import SwiftUI

struct MultiSelectPicker: View {
    var title: String
    var options: [DAYS]
    @Binding var selections: Set<DAYS>
    @State private var isPresented = false
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Button(action: {
                isPresented.toggle()
            }) {
                HStack {
                    Text(title)
                        .foregroundColor(.default)
                    Spacer()
                    Text(displayText)
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $isPresented) {
                
                NavigationView {
                    List {
                        ForEach(options, id: \.self) { option in
                            MultipleSelectionRow(title: option.rawValue, isSelected: selections.contains(option)) {
                                if selections.contains(option) {
                                    selections.remove(option)
                                } else {
                                    selections.insert(option)
                                }
                            }
                        }
                    }
                    .navigationBarTitle("Repeat", displayMode: .inline)
                    .navigationBarItems(
                        trailing: Button("Done") {
                            isPresented = false
                        }
                            .foregroundColor(.blue)
                    )
                }
                
            }
        }
        
    }
    
    
    private var displayText: String {
        if selections.isEmpty {
            return "Select"
        } else if selections.count == options.count {
            return "Every Day"
        } else if selections == Set([.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]) {
            return "Every Weekday"
        } else if selections == Set([.Saturday, .Sunday]) {
            return "Every Weekend"
        } else {
            return selections.map { $0.rawValue }.joined(separator: ", ")
        }
    }
    
}
