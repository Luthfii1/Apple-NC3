//
//  ReminderViewModel.swift
//  NC2
//
//  Created by Syafrie Bachtiar on 12/07/24.
//

import Foundation
import UserNotifications
import WeatherKit

class NotificationManager: ObservableObject{
    static let shared = NotificationManager()
    private init(){}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func scheduleNotifications(date: Date, weather: WeatherCondition, title: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()  // Clear previous notifications
        
        let content = UNMutableNotificationContent()
        content.title = "Check Your \(title) Planned"
        
        switch weather {
        case .clear:
            content.body = String(localized: "It's a beautiful day for \(title)!☀️. Enjoy the clear weather on your way")
        case .thunderstorms:
            content.body = String(localized: "It's a stormy night!⛈️. Don't forget your raincoat and umbrella for your walk to \(title)")
        case .rain:
            content.body = String(localized: "It's a rainy night!🌧️. Remember to bring an umbrella and wear something warm!")
        case .blizzard:
            content.body = String(localized: "It's a chilly night, so make sure to bundle up on your way to \(title)!🧥")
        case .cloudy:
            content.body = String(localized: "It's a cloudy day today. Don't forget your umbrella!☔️")
        case .hot:
            content.body = String(localized: "It's scorching out there!🥵. Don't forget your water bottle and dress cool for the day.")
        case .partlyCloudy:
            content.body = String(localized: "It's partly cloudy, so don't forget your jacket!🧥")
        case .mostlyCloudy:
            content.body = String(localized: "It's mostly cloudy today. Make sure to stay prepared for changing weather!🌥️")
        default:
            content.body = String(localized: "Check the weather before heading out!")
        }

        content.sound = UNNotificationSound.default
        
        // Calculate the notification trigger date (15 minutes before the event date)
        let triggerDate = Calendar.current.date(byAdding: .minute, value: -15, to: date)!
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
}
