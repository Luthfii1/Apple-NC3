//
//  dummyPlanModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

let dummyWeather = Weather(generalDescription: "Sunny", hotDegree: 30, looksLikeHotDegree: 33, UVIndex: 8, Percipitation: 0, AQIndex: 100)

let dummyPlans: [PlanModel] = [
    PlanModel(
        title: "Morning Jog",
        location: "Central Park",
        address: "123 Park Ave, New York, NY",
        coordinatePlace: Coordinate(latitude: 40.785091, longitude: -73.968285),
        weatherPlan: dummyWeather,
        durationPlan: DurationTimePlan(start: "06:00", end: "07:00"),
        isRepeat: true,
        date: Date(timeIntervalSinceReferenceDate: Date().addingTimeInterval(24 * 60 * 60).timeIntervalSinceReferenceDate), // July 14, 2024
        allDay: false,
        suggest: "Wear sunscreen"
    ),
    PlanModel(
        title: "Office Meeting",
        location: "Company HQ",
        address: "456 Business Rd, New York, NY",
        coordinatePlace: Coordinate(latitude: 40.758896, longitude: -73.985130),
        weatherPlan: dummyWeather,
        durationPlan: DurationTimePlan(start: "09:00", end: "10:30"),
        isRepeat: false,
        date: Date(timeIntervalSinceReferenceDate: Date().addingTimeInterval(24 * 60 * 60).timeIntervalSinceReferenceDate), // July 14, 2024
        allDay: false,
        suggest: "Prepare slides"
    ),
    PlanModel(
        title: "Lunch with Clients",
        location: "Downtown Bistro",
        address: "789 Food St, New York, NY",
        coordinatePlace: Coordinate(latitude: 40.730610, longitude: -73.935242),
        weatherPlan: dummyWeather,
        durationPlan: DurationTimePlan(start: "12:00", end: "13:00"),
        isRepeat: false,
        date: Date(timeIntervalSinceReferenceDate: Date().addingTimeInterval(24 * 60 * 60).timeIntervalSinceReferenceDate), // July 14, 2024
        allDay: false,
        suggest: "Discuss project details"
    ),
    PlanModel(
        title: "Afternoon Nap",
        location: "Home",
        address: "101 Home St, New York, NY",
        coordinatePlace: Coordinate(latitude: 40.712776, longitude: -74.005974),
        weatherPlan: dummyWeather,
        durationPlan: DurationTimePlan(start: "14:00", end: "15:00"),
        isRepeat: true,
        date: Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate), // July 13, 2024
        allDay: false,
        suggest: "Set alarm"
    ),
    PlanModel(
        title: "Dinner with Family",
        location: "Family House",
        address: "102 Home St, New York, NY",
        coordinatePlace: Coordinate(latitude: 40.712776, longitude: -74.005974),
        weatherPlan: dummyWeather,
        durationPlan: DurationTimePlan(start: "19:00", end: "21:00"),
        isRepeat: false,
        date: Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate), // July 13, 2024
        allDay: false,
        suggest: "Bring dessert"
    ),
    PlanModel(
        title: "All Day Conference",
        location: "Convention Center",
        address: "303 Event Rd, New York, NY",
        coordinatePlace: Coordinate(latitude: 40.754932, longitude: -73.984016),
        weatherPlan: dummyWeather,
        durationPlan: DurationTimePlan(start: "00:00", end: "23:59"),
        isRepeat: false,
        date: Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate), // July 13, 2024
        allDay: true,
        suggest: "Networking"
    )
]
