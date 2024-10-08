//
//  ReminderViewModel.swift
//  NC2
//
//  Created by Syafrie Bachtiar on 12/07/24.
//

import Foundation
import UserNotifications

class NotificationManager :ObservableObject{
    
//    private let getDetailUseCase: GetAllPlansUseCase
//    
//    init(getDetailUseCase: GetAllPlansUseCase/*, planDetailUseCase: PlanDetailUseCase*/) {
//        self.getDetailUseCase = getDetailUseCase
//    }
    static let shared = NotificationManager()
    
    private init(){}
    
    //Request Izin Awal ke User
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func scheduleNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
 
        notificationCenter.removeAllPendingNotificationRequests()
        
        //Pesan dan Kesan kepada Bachul
        let content = UNMutableNotificationContent()
        
        let temperature = DependencyInjection.shared.getPlanPreviewUseCase.getPlanData().weatherPlan?.first?.temperature.value ?? 0
        let precipitation = DependencyInjection.shared.getPlanPreviewUseCase.getPlanData().weatherPlan?.first?.precipitation ?? .none
        let cuaca = DependencyInjection.shared.getPlanPreviewUseCase.getPlanData().weatherPlan?.first?.condition
        let uv = DependencyInjection.shared.getPlanPreviewUseCase.getPlanData().weatherPlan?.first?.uvIndex.value ?? 0
        
        let title = DependencyInjection.shared.getPlanPreviewUseCase.getPlanData().title
        //GPT Command
        
//        Title:[Plan Title]
//
//        Message:Don’t forget your plan! [Today/Tomorrow]'s weather is [weather condition]. Remember to [CTA]!
//        
        
        content.title = "\(title)"
        
        if cuaca == .clear {
            content.body = String(localized: "It's a beautiful day for \(title)!☀️. Enjoy the clear weather on your way")
        }
        
        else if cuaca == .thunderstorms{
            content.body = String(localized: "It's a stormy night!⛈️. Don't forget your raincoat and umbrella for your walk to \(title)")
        }
        
        else if cuaca == .rain{
            content.body = String(localized: "It's a rainy night!🌧️. Remember to bring an umbrella and wear something warm!")
        }
        
        else if cuaca == .blizzard{
            content.body = String(localized: "It's a chilly night, so make sure to bundle up on your way to \(title)!🧥")
        }
        
        else if cuaca == .cloudy{
            content.body = String(localized: "It's a cloudy day today. Don't forget your umbrella!☔️")
        }
        
        else if cuaca == .hot{
            content.body = String(localized: "It's scorching out there!🥵. Don't forget your water bottle and dress cool for the day.")
        }
        
        else if cuaca == .thunderstorms{
            content.body = String(localized: "Don’t forget your raincoat and umbrella - there are thunderstorms expected!🌧️")
        }
        
        else if cuaca == .rain{
            content.body = String(localized: "Don’t forget your umbrella!☔️. It's raining outside, so be sure to stay dry on your way to \(title).")
        }
        
        else if cuaca == .partlyCloudy{
            content.body = String(localized: "It's partly cloudy, so don't forget your jacket!🧥")
        }
        
//        //Temperature
//        if temperature >= 0{
//            content.title = "Bachul is Coming!!!"
//            content.body = "Mohon untuk tetap stay di rumah"
//        }
//        
//        else if temperature >= 30{
//            content.title = "Bachul is Coming!!!"
//            content.body = "Mohon untuk tetap stay di rumah"
//        }
//        
//        else if temperature >= 30{
//            content.title = "Bachul is Coming!!!"
//            content.body = "Mohon untuk tetap stay di rumah"
//        }
//        
//        //UV
//        else if uv >= 6 {
//            content.title = "🌞 High UV Today! "
//            content.body = "The UV index is very high. Make sure your child wears a hat and sunglasses! 🧢🕶️"
//        }
//        
//        //Precipitation Rain
//        else if precipitation >= 70 {
//            content.title = "🌞 High UV Today! "
//            content.body = "The UV index is very high. Make sure your child wears a hat and sunglasses! 🧢🕶️"
//        }
        
        content.sound = UNNotificationSound.default
        
        //Setiap 10 detik Bachul datang
        for i in 1...2 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 10), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Notifikasi error: \(error.localizedDescription)")
                } else {
                    print("Notifikasi di Set \(i * 10) detik dari sekarang")
                }
            }
        }
    }
    
}
