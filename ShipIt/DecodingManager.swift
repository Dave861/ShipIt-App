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
    var events: [CargusEvent]
}

struct CargusEvent: Decodable {
    var status: String
    var date: String
    var location: String
    var activity: String
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
    let signature: GLSSignature?
    let history: [GLSHistory]
    let owners: [GLSOwner]
    let infos: [GLSInfo]?
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
    let countryName: String?
    let countryCode: String?
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

//MARK: -DPD-
struct DPDShipment: Decodable {
    var events: [DPDEvent]
}

struct DPDEvent: Decodable {
    var status: String
    var date: String
    var location: String
}

//MARK: -Fan Courier-
struct FanCourierDelivery: Decodable {
    let deliverydate: String
    let deliverytime: String
    let deliverylocation: String
    let status: String
    let activity: String
    let content: String?
    let progressdetail: [FanCourierDeliveryEvent]
}

struct FanCourierDeliveryEvent: Decodable {
    let deliverydate: String
    let deliverytime: String
    let deliverylocation: String
    let status: String
    let activity: String
    let content: String?
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
        var events = [CargusEvent]()
        
        var tabel = htmlString.split(separator: "<tbody>")
        tabel.removeFirst()
        
        let rowsUnsplit = String(String(tabel.first!).split(separator: "</tbody>").first!)
        if !rowsUnsplit.contains("</tr>") {
            throw OrderManager.OrderErrors.AWBNotFound
        }
        
        var rows = rowsUnsplit.split(separator: "</tr>")
        rows.removeLast()
        for row in rows {
            var lines = row.split(separator: "</td>")
            lines.removeFirst()
            lines.removeLast()
            var event = CargusEvent(status: "", date: "", location: "", activity: "")
            if lines.count == 4 {
                //Decode Status
                event.status = String(lines[0].split(separator: ">").last ?? "Unknown")
                if event.status.contains("data-column") {
                    event.status = "Unknown"
                }
                //Decode Date
                let fullDate = String(lines[1].split(separator: ">").last ?? "Unknown")
                event.date = fullDate.replacing(" ", with: "T") + ":00"
                //Decode Location
                event.location = String(lines[2].split(separator: ">").last ?? "Unknown")
                if event.location.contains("data-column") {
                    event.location = "Unknown"
                }
                //Decode Activity
                event.activity = String(lines[3].split(separator: ">").last ?? "Unknown")
                if event.activity.contains("data-column") {
                    event.activity = "Unknown"
                }
            } else {
                throw OrderManager.OrderErrors.AWBNotFound
            }
            events.append(event)
        }
        
        return CargusShipment(events: events)
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
    
    func decodeFanCourierJSON(jsonString: String) throws -> FanCourierDelivery {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let shipment: FanCourierDelivery
        do {
            shipment = try decoder.decode(FanCourierDelivery.self, from: jsonData)
        } catch let err {
            print(err)
            throw err
        }
        return shipment
    }
    
    func decodeDPDHTML(htmlString: String) throws -> DPDShipment {
        var events = [DPDEvent]()
        
        var rows = htmlString.split(separator: "</tr>")
        if rows.count <= 2 {
            throw OrderManager.OrderErrors.AWBNotFound
        }
        
        rows.removeFirst()
        rows.removeLast()
        
        
        for row in rows {
            var event = DPDEvent(status: "", date: "", location: "")
            var lines = row.split(separator: "<td>")
            lines.removeFirst()
            //Decode date
            var date = String(lines[0].split(separator: "</td>").first!)
            let dateComponents = date.split(separator: ".")
            date = String(dateComponents[2] + "-" + dateComponents[1] + "-" + dateComponents[0])
            let time = String(lines[1].split(separator: "</td>").first!)
            event.date = date + "T" + time
            
            //Decode status
            var status = String(lines[2].split(separator: "</td>").first!)
            status = String(status.split(separator: "<br>").first!)
            event.status = status
            
            //Decode Location
            var location = String(lines[3].split(separator: "</td>").first!)
            location = String(location.split(separator: "<br>").first!)
            if location == "\n" || location == "" || location == " " {
                event.location = "Unknown"
            } else {
                location = String(location.split(separator: "OR. ").last!)
                event.location = location.lowercased().capitalized
            }
            events.append(event)
        }
        
        return DPDShipment(events: events)
    }
    
}
