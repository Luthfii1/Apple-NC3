//
//  AQIRepositoryProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation

protocol AQIRepositoryProtocol {
    func getAQI(geoLocation: Coordinate) async throws -> AQIResponse
}
