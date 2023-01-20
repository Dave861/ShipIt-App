//
//  ShipItApp.swift
//  ShipIt
//
//  Created by David Retegan on 27.12.2022.
//

import SwiftUI
import BackgroundTasks

@main
struct ShipItApp: App {
    @StateObject private var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: "com.ShipIt.launchToHome") == false {
                WelcomeView() 
                    .environment(\.managedObjectContext, DataController.persistentContainer.viewContext)
            } else {
                HomeView()
                    .environment(\.managedObjectContext, DataController.persistentContainer.viewContext)
            }
        }
        .onChange(of: scenePhase) { _ in
            switch scenePhase {
            case .background: scheduleAppRefresh()
            default: break
            }
        }
        .backgroundTask(.appRefresh("com.ShipIt.backgroundFetch")) {
            await scheduleAppRefresh()
            await backgroundAppFetching()
            NotificationsManager().backgroundFetchTestingNotification()
        }
        
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.ShipIt.backgroundFetch")
        try? BGTaskScheduler.shared.submit(request)
    }
    
    func backgroundAppFetching() async {
        var packages : [Package]!
        do {
            packages = try DataController().getStoredDataFromCoreDataFromBackground() as? [Package]
        } catch let err {
            print(err)
        }
        
        for package in packages {
            let lastStatus = package.statusText!
            var newStatus = "Unattributed"
            while package.eventsArray.count >= 1 {
                package.removeFromEvents(package.eventsArray[package.eventsArray.count-1])
            }
            if package.courier == "DHL" {

            } else if package.courier == "Sameday" {

            } else if package.courier == "GLS" {
                newStatus = await BackgroundOrderManager.sharedInstance.getStatusGLS(awb: package.awb!)
                //Save new status for package
            } else if package.courier == "Cargus" {

            } else if package.courier == "DPD" {

            } else if package.courier == "Fan Courier" {

            }
            if lastStatus != newStatus {
                await NotificationsManager().backgroundFetchNotificationScheduler(package: package, newStatus: newStatus)
            }
        }
    }
}


