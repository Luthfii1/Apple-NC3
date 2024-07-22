import Foundation

struct AQIResponse: Codable {
    let status: String
    let data: AQIData
}

struct AQIData: Codable {
    let aqi: Int
    let idx: Int
    let attributions: [Attribution]
    let city: City
    let dominentpol: String
    let iaqi: IAQI
    let time: Time
    let forecast: ForecastAQI
}

struct Attribution: Codable {
    let url: String?
    let name: String
    let logo: String?
}

struct City: Codable {
    let geo: [Double]
    let name: String
    let url: String
    let location: String
}

struct IAQI: Codable {
    let dew: Measurement?
    let h: Measurement
    let no2: Measurement?
    let p: Measurement
    let pm10: Measurement?
    let so2: Measurement?
    let t: Measurement
    let w: Measurement
    let wg: Measurement?
}

struct Measurement: Codable {
    let v: Double
}

struct Time: Codable {
    let s: String
    let tz: String
    let v: Int
    let iso: String
}

struct ForecastAQI: Codable {
    let daily: Daily
}

struct Daily: Codable {
    let o3: [PollutantData]
    let pm10: [PollutantData]
    let pm25: [PollutantData]
}

struct PollutantData: Codable {
    let avg: Double
    let day: String
    let max: Double
    let min: Double
}
