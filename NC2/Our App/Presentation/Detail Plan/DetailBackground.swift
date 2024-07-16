//
//  DetailBackground.swift
//  NC2
//
//  Created by Glenn Leonali on 16/07/24.
//

import SwiftUI

struct DetailBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Image("Cloudy")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

extension View {
    func detailBackground() -> some View {
        self.modifier(DetailBackground())
    }
}
