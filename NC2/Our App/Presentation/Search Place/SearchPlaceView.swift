//
//  SearchPlanView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//

import SwiftUI
import MapKit

struct SearchPlace: View {
    @ObservedObject var viewModel: SearchPlaceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack{
                
                
                VStack{
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search for a place", text: $viewModel.searchLocation)
                            .autocorrectionDisabled()
                    }
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.primary)
                }
                .padding()
                
                
                
                List(viewModel.suggestedLocations, id: \.self) { location in
                    Button(action: {
                        viewModel.selectLocation(location)
                    }) {
                        VStack(alignment: .leading) {
                            Text(location.name ?? "Unknown")
                                .font(.headline)
                            Text(location.placemark.title ?? "No address")
                                .font(.subheadline)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("New Plan", displayMode: .inline)
            .navigationBarItems(
                trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss() // Dismiss the search view
                }
            )
        }
        
        
    }
    
}

#Preview {
    SearchPlace(viewModel: SearchPlaceViewModel())
}
