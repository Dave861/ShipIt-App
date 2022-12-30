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
    
}
