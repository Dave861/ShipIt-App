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
    
    public func backgroundFetchNotificationScheduler(package: Package) {
        let content = UNMutableNotificationContent()
        content.title = package.name!
        content.body = "Status changed to: \(package.statusText!.lowercased())"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
