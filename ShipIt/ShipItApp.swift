//
//  ShipItApp.swift
//  ShipIt
//
//  Created by David Retegan on 27.12.2022.
//

import SwiftUI

@main
struct ShipItApp: App {
    @StateObject private var dataController = DataController()
    
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
    }
}
