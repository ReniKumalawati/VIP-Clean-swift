//
//  ExtNotificationDel.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 20/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
import UserNotifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        print("receive notification with ID = \(id)")
        completionHandler()
    }
}
