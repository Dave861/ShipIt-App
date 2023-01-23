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
            if package.notifications{
                let lastStatus = package.statusText!
                var newStatus = "Unattributed"
                if package.courier == "DHL" {
                    
                } else if package.courier == "Sameday" {
                    await withCheckedContinuation({ continuation in
                        BackgroundOrderManager.sharedInstance.getSamedayInBG(package: package) { data in
                            var shipment: SamedayParcelsList!
                            do {
                                try shipment = DecodingManager.sharedInstance.decodeSamedayJson(jsonString: "", data: data)
                                newStatus = shipment.awbHistory.first!.statusState
                                print(newStatus)
                                
                                package.statusText = newStatus
                                package.lastDate = String(shipment.awbHistory.first!.statusDate.split(separator: "+")[0])
                                DataController().saveContext()
                            } catch {
                                print("Error decoding response: \(error.localizedDescription)")
                                newStatus = lastStatus
                            }
                            if lastStatus != newStatus {
                                NotificationsManager().backgroundFetchNotificationScheduler(package: package, newStatus: newStatus)
                            }
                            continuation.resume()
                        }
                    })
                } else if package.courier == "GLS" {
                    await withCheckedContinuation({ continuation in
                        BackgroundOrderManager.sharedInstance.getGLSInBG(package: package) { data in
                            var GLSShipment : GLSPackageStatus
                            do {
                                GLSShipment = try DecodingManager.sharedInstance.decodeGLSJSON(jsonString: "", data: data)
                                let shipment = GLSShipment.tuStatus.first
                                print(String((shipment?.history.first?.evtDscr.split(separator: "(").first!)!))
                                newStatus = String((shipment?.history.first?.evtDscr.split(separator: "(").first!)!)
                                
                                package.statusText = newStatus
                                package.lastDate = "\(String(describing: shipment?.history.first?.date ?? "DATE"))T\(String(describing: shipment?.history.first?.time ?? "DATE"))"
                                DataController().saveContext()
                            } catch {
                                print("Error decoding response: \(error.localizedDescription)")
                                newStatus = lastStatus
                            }
                            if lastStatus != newStatus {
                                NotificationsManager().backgroundFetchNotificationScheduler(package: package, newStatus: newStatus)
                            }
                            continuation.resume()
                        }
                    })
                } else if package.courier == "Cargus" {
                    
                } else if package.courier == "DPD" {
                    
                } else if package.courier == "Fan Courier" {
                    await withCheckedContinuation({ continuation in
                        BackgroundOrderManager.sharedInstance.getFanCourierInBG(package: package) { data in
                            var shipment : FanCourierDelivery
                            do {
                                shipment = try DecodingManager.sharedInstance.decodeFanCourierJSON(jsonString: "", data: data)
                                newStatus = shipment.status
                                
                                package.statusText = newStatus
                                package.lastDate = String(shipment.deliverydate.split(separator: ".")[2]) + "-" + String(shipment.deliverydate.split(separator: ".")[1]) + "-" + String(shipment.deliverydate.split(separator: ".")[0]) + "T" + shipment.deliverytime + ":00"
                                DataController().saveContext()
                            } catch {
                                print("Error decoding response: \(error.localizedDescription)")
                                newStatus = lastStatus
                            }
                            if lastStatus != newStatus {
                                NotificationsManager().backgroundFetchNotificationScheduler(package: package, newStatus: newStatus)
                            }
                            continuation.resume()
                        }
                    })
                }
            }
        }
    }
}


