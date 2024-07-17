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
        
        //GPT Command
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
