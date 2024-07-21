//
//  Utils.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 16/07/24.
//

import Foundation
import WeatherKit

class Utils{
    func setBackground(condition: WeatherCondition, isDay: Bool, date: Date/*, state: CARDSTATE*/) -> String {
//        let stateBackground: String = {
//            switch state {
//            case .Card:
//                return "Card"
//            case .Widget:
//                return "Widget"
//            case .Detail:
//                return "Detail"
//            }
//        }()
        
        if !isDay {
            switch condition {
            case .rain, .drizzle, .freezingRain, .freezingDrizzle, .hail, .heavyRain, .sleet, .sunShowers:
                return "rainNight" /*+ stateBackground*/
            case .scatteredThunderstorms, .isolatedThunderstorms, .strongStorms, .thunderstorms, .tropicalStorm:
                return "thunderStormNight" /*+ stateBackground*/
            default:
                return "night" /*+ stateBackground*/
            }
        } else {
            switch condition {
            case .rain, .drizzle, .freezingRain, .freezingDrizzle, .hail, .heavyRain, .sleet, .sunShowers:
                return "rain" /*+ stateBackground*/
            case .scatteredThunderstorms, .isolatedThunderstorms, .strongStorms, .thunderstorms, .tropicalStorm:
                return "thunderStorm" /*+ stateBackground*/
            case .breezy, .cloudy, .foggy, .mostlyCloudy:
                return "cloudy" /*+ stateBackground*/
            case .partlyCloudy:
                return "partlyCloudy" /*+ stateBackground*/
            case .clear, .mostlyClear:
                return "clear" /*+ stateBackground*/
            case .hot:
                return "scorching" /*+ stateBackground*/
            default:
                return "clear" /*+ stateBackground*/
            }
        }
    }
    
    func setCTA(condition: WeatherCondition, isDay: Bool, isBadUV: Bool, isBadAQI: Bool) -> String {
        switch condition {
        case .rain, .drizzle, .freezingRain, .freezingDrizzle, .hail, .heavyRain, .sleet, .sunShowers:
                return "rain" + "CTADetail"
        case .scatteredThunderstorms, .isolatedThunderstorms, .strongStorms, .thunderstorms, .tropicalStorm:
                return "thunderStorm" + "CTADetail"
        case .breezy, .cloudy, .foggy, .mostlyCloudy:
            if isDay, isBadUV, isBadAQI {
                return "cloudy" + "UVAQI" + "CTADetail"
            }else if isDay, isBadUV, !isBadAQI{
                return "cloudy" + "UV" + "CTADetail"
            }else if isDay, !isBadUV, isBadAQI{
                return "cloudy" + "AQI" + "CTADetail"
            }else if isDay, !isBadUV, !isBadAQI{
                return "cloudy" + "Normal" + "CTADetail"
            }else if !isDay, isBadAQI{
                return "nightAQI" + "CTADetail"
            }else if !isDay, !isBadAQI{
                return "nightNormal" + "CTADetail"
            }
        case .partlyCloudy:
            if isDay, isBadUV, isBadAQI {
                return "partlyCloudy" + "UVAQI" + "CTADetail"
            }else if isDay, isBadUV, !isBadAQI{
                return "partlyCloudy" + "UV" + "CTADetail"
            }else if isDay, !isBadUV, isBadAQI{
                return "partlyCloudy" + "AQI" + "CTADetail"
            }else if isDay, !isBadUV, !isBadAQI{
                return "partlyCloudy" + "Normal" + "CTADetail"
            }else if !isDay, isBadAQI{
                return "nightAQI" + "CTADetail"
            }else if !isDay, !isBadAQI{
                return "nightNormal" + "CTADetail"
            }
        case .clear, .mostlyClear:
            if isDay, isBadUV, isBadAQI {
                return "clear" + "UVAQI" + "CTADetail"
            }else if isDay, isBadUV, !isBadAQI{
                return "clear" + "UV" + "CTADetail"
            }else if isDay, !isBadUV, isBadAQI{
                return "clear" + "AQI" + "CTADetail"
            }else if isDay, !isBadUV, !isBadAQI{
                return "clear" + "Normal" + "CTADetail"
            }else if !isDay, isBadAQI{
                return "nightAQI" + "CTADetail"
            }else if !isDay, !isBadAQI{
                return "nightNormal" + "CTADetail"
            }
        case .hot:
            if isDay, isBadUV, isBadAQI {
                return "scorching" + "UVAQI" + "CTADetail"
            }else if isDay, isBadUV, !isBadAQI{
                return "scorching" + "UV" + "CTADetail"
            }else if isDay, !isBadUV, isBadAQI{
                return "scorching" + "AQI" + "CTADetail"
            }else if isDay, !isBadUV, !isBadAQI{
                return "scorching" + "Normal" + "CTADetail"
            }
        default:
            return "clear" + "Normal" + "CTADetail"
        }
        return "clear" + "Normal" + "CTADetail"
    }
}

enum CARDSTATE: String, Codable {
    case Detail, Card, Widget
}
