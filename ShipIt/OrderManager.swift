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
        case AWBNotFound
    }
    
    func getDHLOrderAsync(package: Package) async throws {
        let _headers : HTTPHeaders = ["DHL-API-Key": "demo-key"]//"DEZTyGaGjnvpqmJDcmRhG0Y23QqCfAFA"
        let params : Parameters = ["trackingNumber" : package.awb!]
        
        let getRequest = AF.request("https://api-test.dhl.com/track/shipments", method: .get, parameters: params, encoding: URLEncoding.default, headers: _headers)
                
        var responseJson: String!
        do {
            responseJson = try await getRequest.serializingString().value
        } catch {
            throw OrderErrors.DBFail
        }
        
        var shipment: DHLShipment!
        do {
            shipment = try DecodingManager.sharedInstance.decodeDHLJson(jsonString: responseJson).first
        } catch {
            //Error Management
            var errorResponse: [String: Any]!
            let jsonData = responseJson.data(using: .utf8)!
            do {
                errorResponse = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [String:Any]
            }
            if errorResponse.isEmpty == false {
                throw OrderErrors.AWBNotFound
            } else {
                throw OrderErrors.JSONFail
            }
        }
        
        package.lastDate = String(shipment.status.timestamp.split(separator: "+")[0])
        package.statusText = shipment.status.statusCode.capitalized
        package.address = shipment.status.location.address.addressLocality.lowercased().capitalized
    
        
        for index in 0...shipment.events.count-2 {
            let shipmentEvent = shipment.events[index]
            
            let newEvent = Events(context: contextMOC)
            newEvent.text = shipmentEvent.description
            newEvent.address = shipmentEvent.location?.address.addressLocality.lowercased()
            newEvent.address = newEvent.address?.capitalized
            newEvent.timestamp = String(shipmentEvent.timestamp!.split(separator: "+")[0])
            
            if shipmentEvent.description.lowercased().contains("transit") {
                newEvent.systemImage = "box.truck.fill"
            } else if shipmentEvent.description.lowercased().contains("delivered") {
                newEvent.systemImage = "figure.wave"
            } else if shipmentEvent.description.lowercased().contains("arrived") {
                newEvent.systemImage = "building.fill"
            } else {
                newEvent.systemImage = "shippingbox.fill"
            }
            
            package.addToEvents(newEvent)
        }
    }
    
    func getSamedayOrderAsync(package: Package) async throws {
        let params : Parameters = ["_locale" : "en"]
        let awb = package.awb!//"2emgln96074592001"
        
        let getRequest = AF.request("https://api.sameday.ro/api/public/awb/\(awb)/awb-history", method: .get, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseJson: String!
        do {
            responseJson = try await getRequest.serializingString().value
        } catch {
            throw OrderErrors.DBFail
        }
        
        var shipment: SamedayParcelsList!
        do {
            try shipment = DecodingManager.sharedInstance.decodeSamedayJson(jsonString: responseJson)
        } catch {
            //Error Management
            let decoder = JSONDecoder()
            var samedayError: SamedayError!
            do {
                samedayError = try decoder.decode(SamedayError.self, from: responseJson.data(using: .utf8)!)
            }
            if samedayError != nil {
                throw OrderErrors.AWBNotFound
            } else {
                throw OrderErrors.JSONFail
            }
        }
        
        package.lastDate = String(shipment.awbHistory.first!.statusDate.split(separator: "+")[0])
        package.statusText = shipment.awbHistory.first!.statusState
        package.address = shipment.awbHistory.first!.county
        
        for index in 0...shipment.awbHistory.count-1 {
            let shipmentEvent = shipment.awbHistory[index]
            
            let newEvent = Events(context: contextMOC)
            newEvent.text = shipmentEvent.status
            newEvent.address = shipmentEvent.county
            newEvent.timestamp = String(shipmentEvent.statusDate.split(separator: "+")[0])
            
            if shipmentEvent.status.contains("tranzit") {
                newEvent.systemImage = "box.truck.fill"
            } else if shipmentEvent.status.contains("delivered") {
                newEvent.systemImage = "figure.wave"
            } else {
                newEvent.systemImage = "shippingbox.fill"
            }
            
            package.addToEvents(newEvent)
        }
    }
    
    func getCargusOrderAsync(package: Package) async throws {
        let params : Parameters = ["t" : package.awb!]//"1001651153"]
        
        let getRequest = AF.request("https://www.cargus.ro/tracking-romanian", method: .get, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseHtml: String!
        do {
            responseHtml = try await getRequest.serializingString().value
        } catch {
            throw OrderErrors.DBFail
        }
        
        var cargusShipment: CargusShipment!
        do {
            cargusShipment = try DecodingManager.sharedInstance.decodeCargusHTML(htmlString: responseHtml)
        } catch {
            throw OrderErrors.AWBNotFound
        }
        
        package.lastDate = cargusShipment.events.first!.date
        package.statusText = cargusShipment.events.first!.status
        package.address = cargusShipment.events.first!.location
        
        for event in cargusShipment.events {
            let newEvent = Events(context: contextMOC)
            newEvent.text = event.status
            if event.location != "Unknown" {
                newEvent.address = event.location
            } else {
                newEvent.address = ""
            }
            newEvent.timestamp = event.date
            
            if event.status.lowercased().contains("tranzit") {
                newEvent.systemImage = "box.truck.fill"
            } else if event.status.lowercased().contains("livrare") {
                newEvent.systemImage = "building.fill"
            } else if event.status.lowercased().contains("livrat") {
                newEvent.systemImage = "figure.wave"
            } else {
                newEvent.systemImage = "shippingbox.fill"
            }
            package.addToEvents(newEvent)
        }
    }
    
    func getGLSOrderAsync(package: Package) async throws {
        let params : Parameters = ["match" : package.awb!]//"1111111111"]
        
        let getRequest = AF.request("https://gls-group.com/app/service/open/rest/RO/en/rstt001", method: .get, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseJSON : String!
        do {
            responseJSON = try await getRequest.serializingString().value
        } catch {
            throw OrderErrors.DBFail
        }
        
        var GLSShipment : GLSPackageStatus
        do {
            GLSShipment = try DecodingManager.sharedInstance.decodeGLSJSON(jsonString: responseJSON)
        } catch {
            throw OrderErrors.AWBNotFound
        }
        
        let shipment = GLSShipment.tuStatus.first
        package.address = shipment?.history.first?.address.city.lowercased()
        package.address = package.address?.capitalized
        package.statusText = String((shipment?.history.first?.evtDscr.split(separator: "(").first!)!)
        package.lastDate = "\(String(describing: shipment?.history.first?.date ?? "DATE"))T\(String(describing: shipment?.history.first?.time ?? "DATE"))"
        
        for index in 0...(shipment?.history.count)!-1 {
            let shipmentEvent = shipment?.history[index]
            
            let newEvent = Events(context: contextMOC)
            newEvent.text = shipmentEvent?.evtDscr ?? "DESC"
            newEvent.address = shipmentEvent?.address.city.lowercased() ?? "CITY"
            newEvent.address = newEvent.address?.capitalized
            
            let timestamp = "\(String(describing: shipment?.history[index].date ?? "DATE"))T\(String(describing: shipment?.history[index].time ?? "DATE"))"
            newEvent.timestamp = String(timestamp.split(separator: "+")[0])
            
            if newEvent.text!.contains("left") || newEvent.text!.contains("GLS"){
                newEvent.systemImage = "box.truck.fill"
            } else if newEvent.text!.contains("reached") {
                newEvent.systemImage = "building.fill"
            } else if newEvent.text!.contains("delivered") {
                newEvent.systemImage = "figure.wave"
            } else {
                newEvent.systemImage = "shippingbox.fill"
            }
            
            package.addToEvents(newEvent)
        }
        
    }
    
    func getDPDOrderAsync(package: Package) async throws {
        let params : Parameters = ["shipmentNumber" : package.awb!, //"224884151",
                                   "language" : "en"]
        
        let getRequest = AF.request("https://tracking.dpd.ro/", method: .get, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseHTML : String!
        do {
            responseHTML = try await getRequest.serializingString().value
        } catch {
            throw OrderErrors.DBFail
        }
        
        var shipment : DPDShipment
        do {
            shipment = try DecodingManager.sharedInstance.decodeDPDHTML(htmlString: responseHTML)
        } catch {
            throw OrderErrors.AWBNotFound
        }
        
        package.lastDate = shipment.events.last!.date
        package.statusText = shipment.events.last!.status
        package.address = shipment.events.last!.location
        
        for event in shipment.events {
            let newEvent = Events(context: contextMOC)
            newEvent.text = event.status
            if event.location != "Unknown" {
                newEvent.address = event.location
            } else {
                newEvent.address = ""
            }
            newEvent.timestamp = event.date
            
            if event.status.lowercased().contains("delivery") {
                newEvent.systemImage = "box.truck.fill"
            } else if event.status.lowercased().contains("arrival") {
                newEvent.systemImage = "building.fill"
            } else if event.status.lowercased().contains("delivered") {
                newEvent.systemImage = "figure.wave"
            } else {
                newEvent.systemImage = "shippingbox.fill"
            }
            package.addToEvents(newEvent)
        }
    }
    
}
