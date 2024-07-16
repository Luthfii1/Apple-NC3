//
//  LocationModel.swift
//  NC2
//
//  Created by Felicia Himawan on 16/07/24.
//

import Foundation

struct Location: Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var nameLocation: String
    var detailAddress: String
    var coordinatePlace: Coordinate
}
