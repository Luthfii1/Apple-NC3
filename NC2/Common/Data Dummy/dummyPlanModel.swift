//
//  dummyPlanModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation
import WeatherKit

//// Dummy Weather Data
//let dummyHourWeather = HourWeather(
//    temperature: Measurement(value: 25.0, unit: UnitTemperature.celsius),
//    condition: .clear,
//    forecastStart: Date(),
//    forecastEnd: Date()
//)
//let dummyWeatherPlan = Forecast<HourWeather>(dailyForecast: [dummyHourWeather])

// Dummy Data
let dummyPlans: [PlanModel] = [
    PlanModel(
        title: "Morning Jog",
        location: Location(nameLocation: "Central Park", detailAddress: "123 Park Ave, New York, NY", coordinatePlace: Coordinate(longitude: -73.968285, latitude: 40.785091)),
//        weatherPlan: dummyWeatherPlan,
        durationPlan: DurationTimePlan(start: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 14, hour: 6, minute: 0).date!, end: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 14, hour: 7, minute: 0).date!),
        daysRepeat: [.Sunday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday],
        planCategory: .Repeat,
        reminder: ._5MinBefore,
        allDay: false,
        suggest: "Wear sunscreen"
    ),
    PlanModel(
        title: "Office Meeting",
        location: Location(nameLocation: "Company HQ", detailAddress: "456 Business Rd, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
//        weatherPlan: dummyWeatherPlan,
        durationPlan: DurationTimePlan(start: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 14, hour: 9, minute: 0).date!, end: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 14, hour: 10, minute: 30).date!),
        planCategory: .Event,
        reminder: ._10MinBefore,
        allDay: false,
        suggest: "Prepare slides"
    ),
    PlanModel(
        title: "Lunch with Clients",
        location: Location(nameLocation: "Downtown Bistro", detailAddress: "789 Food St, New York, NY", coordinatePlace: Coordinate(longitude: -73.935242, latitude: 40.730610)),
//        weatherPlan: dummyWeatherPlan,
        durationPlan: DurationTimePlan(start: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 14, hour: 12, minute: 0).date!, end: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 14, hour: 13, minute: 0).date!),
        planCategory: .Event,
        reminder: ._15MinBefore,
        allDay: false,
        suggest: "Discuss project details"
    ),
    PlanModel(
        title: "Afternoon Nap",
        location: Location(nameLocation: "Home", detailAddress: "101 Home St, New York, NY", coordinatePlace: Coordinate(longitude: -74.005974, latitude: 40.712776)),
//        weatherPlan: dummyWeatherPlan,
        durationPlan: DurationTimePlan(start: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 13, hour: 14, minute: 0).date!, end: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 13, hour: 15, minute: 0).date!),
        daysRepeat: [.Sunday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday],
        planCategory: .Repeat,
        reminder: ._30MinBefore,
        allDay: false,
        suggest: "Set alarm"
    ),
    PlanModel(
        title: "Dinner with Family",
        location: Location(nameLocation: "Family House", detailAddress: "102 Home St, New York, NY", coordinatePlace: Coordinate(longitude: -74.005974, latitude: 40.712776)),
//        weatherPlan: dummyWeatherPlan,
        durationPlan: DurationTimePlan(start: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 13, hour: 19, minute: 0).date!, end: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 13, hour: 21, minute: 0).date!),
        planCategory: .Event,
        reminder: ._1HourBefore,
        allDay: false,
        suggest: "Bring dessert"
    ),
    PlanModel(
        title: "All Day Conference",
        location: Location(nameLocation: "Convention Center", detailAddress: "303 Event Rd, New York, NY", coordinatePlace: Coordinate(longitude: -73.984016, latitude: 40.754932)),
//        weatherPlan: dummyWeatherPlan,
        durationPlan: DurationTimePlan(start: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 13, hour: 0, minute: 0).date!, end: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 13, hour: 23, minute: 59).date!),
        planCategory: .Event,
        reminder: .None,
        allDay: true,
        suggest: "Networking"
    )
]
