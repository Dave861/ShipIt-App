//
//  DecodingManager.swift
//  ShipIt
//
//  Created by David Retegan on 30.12.2022.
//

import Foundation

//MARK: -DHL Structs-
struct DHLShipments: Decodable {
    let shipments: [DHLShipment]
}

struct DHLShipment: Decodable {
    let id: String
    let service: String
    let origin: DHLOrigin
    let destination: DHLDestination
    let status: DHLStatus
    let details: DHLDetails
    let events: [DHLEvent]
}

struct DHLOrigin: Decodable {
    let address: DHLAddress
    let servicePoint: DHLServicePoint
}

struct DHLDestination: Decodable {
    let address: DHLAddress
    let servicePoint: DHLServicePoint
}

struct DHLAddress: Decodable {
    let addressLocality: String
}

struct DHLServicePoint: Decodable {
    let url: String
    let label: String
}

struct DHLStatus: Decodable {
    let timestamp: String
    let location: DHLLocation
    let statusCode: String
    let status: String
    let description: String
}

struct DHLLocation: Decodable {
    let address: DHLAddress
}

struct DHLDetails: Decodable {
    let proofOfDeliverySignedAvailable: Bool
}

struct DHLEvent: Decodable {
    let timestamp: String?
    let location: DHLLocation?
    let description: String
}

//MARK: -Cargus Structs-
struct CargusShipment: Decodable {
    var status: String
    var date: Date
    var location: String
    var lastEvent: String
}

//MARK: -Class-
class DecodingManager {
    
    static let sharedInstance = DecodingManager()
    
    private init() {}
    
    func decodeDHLJson(jsonString: String) throws -> [DHLShipment] {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        let shipments: DHLShipments
        do {
            shipments = try decoder.decode(DHLShipments.self, from: jsonData)
        } catch let err {
            throw err
        }

        return shipments.shipments
    }
    
    func decodeCargusHTML(htmlString: String) throws -> CargusShipment {
        var shipment = CargusShipment(status: "", date: Date(), location: "", lastEvent: "")
        
        var rows = htmlString.split(separator: "</td>")
        rows.remove(at: 0)
        rows.removeLast()
        
        if rows.count == 4 {
            //Decode Status
            shipment.status = String(rows[0].split(separator: ">").last ?? "Unknown")
            if shipment.status.contains("data-column") {
                shipment.status = "Unknown"
            }
            //Decode Date
            let fullDate = String(rows[1].split(separator: ">").last ?? "Unknown")
            shipment.date = String(fullDate.split(separator: " ").first ?? "1978-30-02").turnToDate()
            //Decode Location
            shipment.location = String(rows[2].split(separator: ">").last ?? "Unknown")
            if shipment.location.contains("data-column") {
                shipment.location = "Unknown"
            }
            //Decode Last Event
            shipment.lastEvent = String(rows[3].split(separator: ">").last ?? "Unknown")
            if shipment.lastEvent.contains("data-column") {
                shipment.lastEvent = "Unknown"
            }
        } else {
            throw OrderManager.OrderErrors.AWBNotFound
        }
        
        return shipment
    }
    
}
