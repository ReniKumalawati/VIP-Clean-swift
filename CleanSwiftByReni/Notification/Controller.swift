//
//  Controller.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 16/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
import UserNotifications
class Controller {
    
    let center = UNUserNotificationCenter.current()
    
    init() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) {(granted, error) in
            if granted {
                print("yeay!")
            } else {
                print("prohibited")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Let wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents , repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triger)
        center.add(request)
        
    }
}
