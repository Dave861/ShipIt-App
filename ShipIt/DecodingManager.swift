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

//MARK: -Sameday Structs-
struct SamedayError: Decodable {
    let error: SamedayErrorDetails
}

struct SamedayErrorDetails: Decodable {
    let code: Int
    let message: String
}

struct SamedayHistory: Decodable {
    let county: String
    let country: String
    let status: String
    let statusId: Int
    let statusState: String
    let statusStateId: Int
    let transitLocation: String
    let statusDate: String//Date
}

struct SamedayParcel: Decodable {
    let county: String
    let country: String
    let status: String
    let statusId: Int
    let statusState: String
    let statusStateId: Int
    let transitLocation: String
    let statusDate: String//Date
    let parcelAwbNumber: String
    let createdBy: Int
    let reasonId: String
    let reason: String
    let inReturn: Bool
}

struct SamedayParcelsList: Decodable {
    let awbNumber: String
    let awbHistory: [SamedayHistory]
    let parcelsList: [String: [SamedayParcel]]
}

//MARK: -GLS Structs-
struct GLSPackageStatus: Codable {
    let tuStatus: [GLSStatus]
}

struct GLSStatus: Codable {
    let references: [GLSReference]
    let signature: GLSSignature
    let history: [GLSHistory]
    let owners: [GLSOwner]
    let infos: [GLSInfo]
}

struct GLSReference: Codable {
    let type: String
    let name: String
    let value: String
}

struct GLSSignature: Codable {
    let validate: Bool
    let name: String
    let value: String
}

struct GLSHistory: Codable {
    let date: String
    let time: String
    let address: GLSAddress
    let evtDscr: String
}

struct GLSAddress: Codable {
    let city: String
    let countryName: String
    let countryCode: String
    let name: String?
}

struct GLSOwner: Codable {
    let type: String
    let code: String
}

struct GLSInfo: Codable {
    let type: String
    let value: String
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
    
    func decodeSamedayJson(jsonString: String) throws -> SamedayParcelsList {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let shipment: SamedayParcelsList
        do {
            shipment = try decoder.decode(SamedayParcelsList.self, from: jsonData)
        } catch let err {
            print(err.localizedDescription)
            throw err
            
        }
        
        return shipment
    }
    
    func decodeCargusHTML(htmlString: String) throws -> CargusShipment {
        var shipment = CargusShipment(status: "", date: Date(), location: "", lastEvent: "")
        
        var rows = htmlString.split(separator: "</td>")
        if rows.count == 1 {
            throw OrderManager.OrderErrors.AWBNotFound
        }
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
    
    func decodeGLSJSON(jsonString: String) throws -> GLSPackageStatus {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let shipment: GLSPackageStatus
        do {
            shipment = try decoder.decode(GLSPackageStatus.self, from: jsonData)
        } catch let err {
            print(err)
            throw err
        }
        return shipment
    }
    
}
