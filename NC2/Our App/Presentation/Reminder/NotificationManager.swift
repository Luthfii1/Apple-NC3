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
        
        let temperature = Test.shared.getPlanPreviewUseCase.getPlanData().weatherPlan?.hotDegree ?? 0
        let precipitation = Test.shared.getPlanPreviewUseCase.getPlanData().weatherPlan?.Percipitation ?? 0
        let cuaca = Test.shared.getPlanPreviewUseCase.getPlanData().weatherPlan?.generalDescription
        let uv = Test.shared.getPlanPreviewUseCase.getPlanData().weatherPlan?.UVIndex ?? 0
        
        //GPT Command
        //Temperature
        if temperature >= 0{
            content.title = "Bachul is Coming!!!"
            content.body = "Mohon untuk tetap stay di rumah"
        }
        
        else if temperature >= 30{
            content.title = "Bachul is Coming!!!"
            content.body = "Mohon untuk tetap stay di rumah"
        }
        
        else if temperature >= 30{
            content.title = "Bachul is Coming!!!"
            content.body = "Mohon untuk tetap stay di rumah"
        }
        
        //UV
        else if uv >= 6 {
            content.title = "🌞 High UV Today! "
            content.body = "The UV index is very high. Make sure your child wears a hat and sunglasses! 🧢🕶️"
        }
        
        //Precipitation Rain
        else if precipitation >= 70 {
            content.title = "🌞 High UV Today! "
            content.body = "The UV index is very high. Make sure your child wears a hat and sunglasses! 🧢🕶️"
        }
        
        content.sound = UNNotificationSound.default
        
        //Setiap 10 detik Bachul datang
        for i in 1...10 {
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
