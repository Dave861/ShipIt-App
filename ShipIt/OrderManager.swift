//
//  OrderManager.swift
//  ShipIt
//
//  Created by Mihnea on 12/29/22.
//

import Foundation
import CoreData
import UIKit
import Alamofire

struct OrderProcessingResults {
    let status : String
    let timestamp : String
    let address : String
}

class OrderManager: NSObject {
    
    var contextMOC: NSManagedObjectContext!
    
    init(contextMOC: NSManagedObjectContext!) {
        self.contextMOC = contextMOC
    }
    
    enum OrderErrors: Error {
        case DBFail
        case JSONFail
        case UnknownFail
    }
    
    func getDHLOrderAsync(package: Package) async throws {
        let _headers : HTTPHeaders = ["DHL-API-Key": "DEZTyGaGjnvpqmJDcmRhG0Y23QqCfAFA"]
        let params : Parameters = ["trackingNumber" : package.awb!]
        
        let getRequest = AF.request("https://api-eu.dhl.com/track/shipments", method: .get, parameters: params, encoding: URLEncoding.default, headers: _headers)
                
        var responseJson: String!
        do {
            responseJson = try await getRequest.serializingString().value
        } catch {
            throw OrderErrors.DBFail
        }
        
        var shipment: DHLShipment!
        do {
            shipment = try DecodingManager.sharedInstance.decodeDHLJson(jsonString: responseJson!).first
        } catch {
            throw OrderErrors.JSONFail
        }
        
        package.lastDate = String(shipment.status.timestamp.split(separator: "T")[0])
        package.statusText = shipment.status.statusCode.capitalized
        package.address = shipment.status.location.address.addressLocality.lowercased().capitalized
    
        
        for index in 0...shipment.events.count-2 {
            let shipmentEvent = shipment.events[index]
            
            let newEvent = Events(context: contextMOC)
            newEvent.text = shipmentEvent.description
            newEvent.address = shipmentEvent.location?.address.addressLocality.lowercased()
            newEvent.address = newEvent.address?.capitalized
            newEvent.timestamp = String(shipmentEvent.timestamp!.split(separator: "T")[0])
            
            print(shipmentEvent.description)
            if shipmentEvent.description.contains("transit") {
                newEvent.systemImage = "box.truck.fill"
            } else if shipmentEvent.description.contains("Arrived") {
                newEvent.systemImage = "building.fill"
            } else {
                newEvent.systemImage = "box.fill"
            }
            
            package.addToEvents(newEvent)
        }
        
    }
}
