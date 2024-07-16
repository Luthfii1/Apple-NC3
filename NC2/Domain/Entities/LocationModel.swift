//
//  LocationModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import Foundation

struct Location: Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var nameLocation: String
    var detailAddress: String
    var coordinatePlace: Coordinate
}
