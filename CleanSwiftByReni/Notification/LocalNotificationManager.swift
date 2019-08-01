//
//  LocalNotificationManager.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 20/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
import UserNotifications
class LocalNotificationManager {
    var notifications = [Notification]()
    
    func listScheduleNotifications()  {
        UNUserNotificationCenter.current().getPendingNotificationRequests{notifications in
            let calendar = Calendar.current
            print("jumlah notif: \(notifications.count)")
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    private func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional :
                self.scheduleNotifications()
            default:
                break
            }
            
        }
    }
    
    private func scheduleNotifications(){
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else {return}
                print("Notification Scheduled! --- ID = \(notification.id)")
            }
        }
    }
}
