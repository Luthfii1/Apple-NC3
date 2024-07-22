//
//  AQIRemoteDataSource.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation

enum AQIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
}

class AQIRemoteDataSource: AQIRemoteDataSourceProtocol {
    func getAQI(geoLocation: Coordinate) async throws -> AQIResponse {
        let token: String = "c3d3b4df7ca23f78344d003299c2eebbbdd30c92"
        
        guard let url = URL(string: "https://api.waqi.info/feed/geo:\(geoLocation.longitude);\(geoLocation.latitude)/?token=\(token)") else {
            fatalError("Invalid API endpoint URL")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server: \(response)")
                throw AQIError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let aqiResponse = try decoder.decode(AQIResponse.self, from: data)
                return aqiResponse
            } catch {
                print("Error decoding JSON AQI: \(error.localizedDescription)")
                throw AQIError.decodingError(error)
            }
        } catch {
            print("Error fetching data AQI: \(error.localizedDescription)")
            throw AQIError.networkError(error)
        }
    }
}
