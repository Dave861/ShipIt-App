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
                    .environment(\.managedObjectContext, dataController.persistentContainer.viewContext)
            } else {
                HomeView()
                    .environment(\.managedObjectContext, dataController.persistentContainer.viewContext)
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
    
    func backgroundAppFetching() {
        let packages = DataController().getStoredDataFromCoreData() as! [Package]
        for package in packages {
            let lastStatus = package.statusText!
            while package.eventsArray.count >= 1 {
                package.removeFromEvents(package.eventsArray[package.eventsArray.count-1])
            }
            if package.courier == "DHL" {
                Task(priority: .high) {
                    do {
                        try await OrderManager(contextMOC: DataController().persistentContainer.viewContext).getDHLOrderAsync(package: package)
                        do {
                            try DataController().persistentContainer.viewContext.save()
                            NotificationsManager().backgroundFetchNotificationScheduler(package: package)
                        } catch let err {
                            print(err)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            } else if package.courier == "Sameday" {
                Task(priority: .high) {
                    do {
                        try await OrderManager(contextMOC: DataController().persistentContainer.viewContext).getSamedayOrderAsync(package: package)
                        do {
                            try DataController().persistentContainer.viewContext.save()
                            NotificationsManager().backgroundFetchNotificationScheduler(package: package)
                        } catch let err {
                            print(err)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            } else if package.courier == "GLS" {
                Task(priority: .high) {
                    do {
                        try await OrderManager(contextMOC: DataController().persistentContainer.viewContext).getGLSOrderAsync(package: package, isBackgroundThread: true)
                        do {
                            try DataController().persistentContainer.viewContext.save()
                            NotificationsManager().backgroundFetchNotificationScheduler(package: package)
                        } catch let err {
                            print(err)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            } else if package.courier == "Cargus" {
                Task(priority: .high) {
                    do {
                        try await OrderManager(contextMOC: DataController().persistentContainer.viewContext).getCargusOrderAsync(package: package)
                        do {
                            try DataController().persistentContainer.viewContext.save()
                            NotificationsManager().backgroundFetchNotificationScheduler(package: package)
                        } catch let err {
                            print(err)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            } else if package.courier == "DPD" {
                Task(priority: .high) {
                    do {
                        try await OrderManager(contextMOC: DataController().persistentContainer.viewContext).getDPDOrderAsync(package: package)
                        do {
                            try DataController().persistentContainer.viewContext.save()
                            NotificationsManager().backgroundFetchNotificationScheduler(package: package)
                        } catch let err {
                            print(err)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            } else if package.courier == "Fan Courier" {
                Task(priority: .high) {
                    do {
                        try await OrderManager(contextMOC: DataController().persistentContainer.viewContext).getFanCourierOrderAsync(package: package)
                        do {
                            try DataController().persistentContainer.viewContext.save()
                            NotificationsManager().backgroundFetchNotificationScheduler(package: package)
                        } catch let err {
                            print(err)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            }
            if lastStatus != package.statusText {
                NotificationsManager().backgroundFetchNotificationScheduler(package: package)
            }
        }
    }
}
