//
//  CustomRoundedCorner.swift
//  NC2
//
//  Created by Felicia Himawan on 17/07/24.
//

import SwiftUI



struct CustomRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func customCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CustomRoundedCorner(radius: radius, corners: corners))
    }
}
