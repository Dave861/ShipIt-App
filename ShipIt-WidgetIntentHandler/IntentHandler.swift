//
//  IntentHandler.swift
//  ShipIt-WidgetIntentHandler
//
//  Created by David Retegan on 05.01.2023.
//

import Intents
import CoreData

class IntentHandler: INExtension, ConfigurationIntentHandling {
    
    func provideTrackedPackageOptionsCollection(for intent: ConfigurationIntent) async throws -> INObjectCollection<WidgetPackage> {
        let results =  DataController.shared.getStoredDataFromCoreData() as! [Package]
        var widgetPackages = [WidgetPackage]()
        for result in results {
            let widgetPackage = WidgetPackage(identifier: result.id?.description, display: result.name!)
            widgetPackage.awb = result.awb
            widgetPackage.packageName = result.name!
            widgetPackage.statusDate = result.lastDate!.turnToDate().turnToReadableString()
            widgetPackage.packageStatus = result.statusText!
            widgetPackage.packageCourier = result.courier!
            widgetPackages.append(widgetPackage)
        }
        let collection = INObjectCollection(items: widgetPackages)
        return collection
    }
    
    func provideTrackedPackageMOptionsCollection(for intent: ConfigurationIntent) async throws -> INObjectCollection<WidgetPackage> {
        let results =  DataController.shared.getStoredDataFromCoreData() as! [Package]
        var widgetPackages = [WidgetPackage]()
        for result in results {
            let widgetPackage = WidgetPackage(identifier: result.id?.description, display: result.name!)
            widgetPackage.awb = result.awb
            widgetPackage.packageName = result.name!
            widgetPackage.statusDate = result.lastDate!.turnToDate().turnToReadableString()
            widgetPackage.packageStatus = result.statusText!
            widgetPackage.packageCourier = result.courier!
            widgetPackages.append(widgetPackage)
        }
        let collection = INObjectCollection(items: widgetPackages)
        return collection
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
