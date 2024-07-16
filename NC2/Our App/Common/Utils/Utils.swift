//
//  Utils.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 16/07/24.
//

import Foundation
import WeatherKit

class Utils{
    func setBackground(condition: WeatherCondition, date: Date, state: CARDSTATE) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        var stateBackground: String = {
            switch state {
            case .Card:
                return "Card"
            case .Widget:
                return "Widget"
            case .Detail:
                return "Detail"
            }
        }()
        
        if hour >= 18 {
            switch condition {
            case .rain, .drizzle, .freezingRain, .freezingDrizzle, .hail, .heavyRain, .sleet, .sunShowers:
                return "rain" + stateBackground
            case .scatteredThunderstorms, .isolatedThunderstorms, .strongStorms, .thunderstorms, .tropicalStorm:
                return "thunderStorm" + stateBackground
            default:
                return "night" + stateBackground
            }
        } else {
            switch condition {
            case .rain, .drizzle, .freezingRain, .freezingDrizzle, .hail, .heavyRain, .sleet, .sunShowers:
                return "rain" + stateBackground
            case .scatteredThunderstorms, .isolatedThunderstorms, .strongStorms, .thunderstorms, .tropicalStorm:
                return "thunderStorm" + stateBackground
            case .breezy, .cloudy, .foggy, .mostlyCloudy:
                return "cloudy" + stateBackground
            case .partlyCloudy:
                return "partlyCloudy" + stateBackground
            case .clear, .mostlyClear:
                return "clear" + stateBackground
            case .hot:
                return "scorching" + stateBackground
            default:
                return "clear" + stateBackground
            }
        }
    }
}

enum CARDSTATE: String, Codable {
    case Detail, Card, Widget
}
