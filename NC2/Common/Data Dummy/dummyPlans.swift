//
//  dummyPlans.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 13/07/24.
//

import Foundation

let dummyPlansEntity: [PlanCardEntity] = [
    PlanCardEntity(
        id: UUID(),
        title: "Morning Run",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date(), end: Date().addingTimeInterval(3600)),
        location: Location(nameLocation: "Central Park", detailAddress: "123 Park Ave, New York, NY", coordinatePlace: Coordinate(longitude: -73.968285, latitude: 40.785091)),
        temperature: 18,
        weatherDescription: "Clear skies",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Team Meeting",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(10800), end: Date().addingTimeInterval(14400)),
        location: Location(nameLocation: "Conference Room 1", detailAddress: "456 Business Rd, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
        temperature: 22,
        weatherDescription: "Sunny",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Lunch Break",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(21600), end: Date().addingTimeInterval(25200)),
        location: Location(nameLocation: "Cafeteria", detailAddress: "789 Food St, New York, NY", coordinatePlace: Coordinate(longitude: -73.935242, latitude: 40.730610)),
        temperature: 24,
        weatherDescription: "Partly cloudy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Project Briefing",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(28800), end: Date().addingTimeInterval(34200)),
        location: Location(nameLocation: "Meeting Room 2", detailAddress: "101 Tech Blvd, New York, NY", coordinatePlace: Coordinate(longitude: -73.982620, latitude: 40.759040)),
        temperature: 22,
        weatherDescription: "Sunny",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Fitness Session",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(39600), end: Date().addingTimeInterval(43200)),
        location: Location(nameLocation: "Fitness Center", detailAddress: "123 Workout St, New York, NY", coordinatePlace: Coordinate(longitude: -73.978256, latitude: 40.754932)),
        temperature: 20,
        weatherDescription: "Clear skies",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Dinner Out",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(68400), end: Date().addingTimeInterval(75600)),
        location: Location(nameLocation: "Downtown Restaurant", detailAddress: "456 Foodie Lane, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
        temperature: 21,
        weatherDescription: "Cloudy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Reading Time",
        allDay: true,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(0), end: Date().addingTimeInterval(86400)),
        location: Location(nameLocation: "Home", detailAddress: "123 Home St, New York, NY", coordinatePlace: Coordinate(longitude: -74.005974, latitude: 40.712776)),
        temperature: 20,
        weatherDescription: "Rainy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Weekend Getaway",
        allDay: true,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(0), end: Date().addingTimeInterval(86400)),
        location: Location(nameLocation: "Mountain Resort", detailAddress: "789 Mountain Rd, New York, NY", coordinatePlace: Coordinate(longitude: -73.935242, latitude: 40.730610)),
        temperature: 15,
        weatherDescription: "Snowy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Family Brunch",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(39600), end: Date().addingTimeInterval(43200)),
        location: Location(nameLocation: "Family Home", detailAddress: "101 Family St, New York, NY", coordinatePlace: Coordinate(longitude: -74.005974, latitude: 40.712776)),
        temperature: 23,
        weatherDescription: "Sunny",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Yoga Session",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(28800), end: Date().addingTimeInterval(32400)),
        location: Location(nameLocation: "Yoga Studio", detailAddress: "456 Wellness Blvd, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
        temperature: 19,
        weatherDescription: "Clear skies",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Grocery Run",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(36000), end: Date().addingTimeInterval(39600)),
        location: Location(nameLocation: "Local Market", detailAddress: "789 Market St, New York, NY", coordinatePlace: Coordinate(longitude: -73.935242, latitude: 40.730610)),
        temperature: 21,
        weatherDescription: "Cloudy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Afternoon Rest",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(50400), end: Date().addingTimeInterval(54000)),
        location: Location(nameLocation: "Home", detailAddress: "123 Home St, New York, NY", coordinatePlace: Coordinate(longitude: -74.005974, latitude: 40.712776)),
        temperature: 20,
        weatherDescription: "Partly cloudy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Evening Stroll",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(64800), end: Date().addingTimeInterval(68400)),
        location: Location(nameLocation: "Neighborhood Park", detailAddress: "456 Park Lane, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
        temperature: 18,
        weatherDescription: "Clear skies",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Movie Night",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(72000), end: Date().addingTimeInterval(79200)),
        location: Location(nameLocation: "Living Room", detailAddress: "123 Home St, New York, NY", coordinatePlace: Coordinate(longitude: -74.005974, latitude: 40.712776)),
        temperature: 22,
        weatherDescription: "Cloudy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Midnight Snack",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(82800), end: Date().addingTimeInterval(84600)),
        location: Location(nameLocation: "Kitchen", detailAddress: "123 Home St, New York, NY", coordinatePlace: Coordinate(longitude: -74.005974, latitude: 40.712776)),
        temperature: 20,
        weatherDescription: "Clear skies",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Beach Outing",
        allDay: true,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(0), end: Date().addingTimeInterval(86400)),
        location: Location(nameLocation: "Sunny Beach", detailAddress: "456 Beach Rd, New York, NY", coordinatePlace: Coordinate(longitude: -73.935242, latitude: 40.730610)),
        temperature: 28,
        weatherDescription: "Sunny",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Museum Tour",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(36000), end: Date().addingTimeInterval(43200)),
        location: Location(nameLocation: "City Museum", detailAddress: "789 Museum St, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
        temperature: 23,
        weatherDescription: "Rainy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Coffee Break",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(54000), end: Date().addingTimeInterval(55800)),
        location: Location(nameLocation: "Coffee Shop", detailAddress: "123 Coffee St, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
        temperature: 22,
        weatherDescription: "Partly cloudy",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Networking Event",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(64800), end: Date().addingTimeInterval(72000)),
        location: Location(nameLocation: "Hotel Ballroom", detailAddress: "456 Business Rd, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
        temperature: 21,
        weatherDescription: "Clear skies",
        backgroundCard: "clearCard"
    ),
    PlanCardEntity(
        id: UUID(),
        title: "Book Club Meeting",
        allDay: false,
        durationPlan: DurationTimePlan(start: Date().addingTimeInterval(68400), end: Date().addingTimeInterval(72000)),
        location: Location(nameLocation: "Library", detailAddress: "789 Library Rd, New York, NY", coordinatePlace: Coordinate(longitude: -73.985130, latitude: 40.758896)),
        temperature: 22,
        weatherDescription: "Cloudy",
        backgroundCard: "clearCard"
    )
]
