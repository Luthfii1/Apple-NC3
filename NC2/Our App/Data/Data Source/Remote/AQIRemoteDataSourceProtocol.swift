//
//  AQIRemoteDataSourceProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation

protocol AQIRemoteDataSourceProtocol {
    func getAQI(geoLocation: Coordinate) async throws -> AQIResponse
}
