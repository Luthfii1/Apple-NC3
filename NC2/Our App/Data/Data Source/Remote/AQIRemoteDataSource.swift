//
//  AQIRemoteDataSource.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation

class AQIRemoteDataSource: AQIRemoteDataSourceProtocol {
    func getAQI(geoLocation: Coordinate) async throws -> AQIResponse {
        let token: String = "c3d3b4df7ca23f78344d003299c2eebbbdd30c92"
        
        guard let url = URL(string: "https://api.waqi.info/feed/geo:\(geoLocation.longitude);\(geoLocation.latitude)/?token=\(token)") else {
            fatalError("Invalid API endpoint URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            fatalError("Invalid response from server")
        }
        
        do {
            let decoder = JSONDecoder()
            let aqiResponse = try decoder.decode(AQIResponse.self, from: data)
            return aqiResponse
        } catch {
            fatalError("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}

//@Published var aqiData: AQIData?
//
//    init() {
//        fetchData()
//    }
//
//    func fetchData() {
//        guard let url = URL(string: "YOUR_API_ENDPOINT_URL") else {
//            fatalError("Invalid API endpoint URL")
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                fatalError("No data in response: \(error?.localizedDescription ?? "Unknown error")")
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(AQIResponse.self, from: data)
//                DispatchQueue.main.async {
//                    self.aqiData = response.data
//                }
//            } catch {
//                fatalError("Error decoding JSON: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
