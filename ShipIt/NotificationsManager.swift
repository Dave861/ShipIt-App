//
//  Notifications Manager.swift
//  ShipIt
//
//  Created by Mihnea on 1/8/23.
//

import Foundation
import UserNotifications
import BackgroundTasks
import UIKit

public class NotificationsManager {
    public func requestPermisions() {
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func backgroundFetchTestingNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Background fetch"
        content.body = "Background fetch initiated with succes"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    public func backgroundFetchTestingNotificationWContent(contentBody: String) {
        let content = UNMutableNotificationContent()
        content.title = "Background fetch"
        content.body = contentBody
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    public func backgroundFetchNotificationScheduler(package: Package, newStatus: String) {
        let content = UNMutableNotificationContent()
        content.title = package.name!
        if let address = package.address {
            content.body = "\(newStatus) in \(address)"
        } else {
            content.body = newStatus
        }
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
