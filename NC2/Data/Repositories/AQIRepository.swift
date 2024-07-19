//
//  AQIRepository.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation

class AQIRepository: AQIRepositoryProtocol {
    private let AQIRemoteDataSource: AQIRemoteDataSourceProtocol
    
    init(AQIRemoteDataSource: AQIRemoteDataSourceProtocol) {
        self.AQIRemoteDataSource = AQIRemoteDataSource
    }
    
    func getAQI(geoLocation: Coordinate) async throws -> AQIResponse {
        let dataAQIRemote = try await AQIRemoteDataSource.getAQI(geoLocation: geoLocation)
        
        return dataAQIRemote
    }
}
