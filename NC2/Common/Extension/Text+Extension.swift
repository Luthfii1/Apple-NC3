//
//  Text+Extension.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import SwiftUI

struct ShadowedTextModifier: ViewModifier {
    var font: Font
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .bold()
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.4), radius: 10, x: 2, y: 2)
    }
}

extension View {
    func shadowedText(font: Font) -> some View {
        self.modifier(ShadowedTextModifier(font: font))
    }
}
