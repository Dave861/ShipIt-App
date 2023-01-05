//
//  WidgetOrderManager.swift
//  ShipIt-WidgetIntentHandler
//
//  Created by David Retegan on 05.01.2023.
//

import Foundation
import Alamofire

class WidgetOrderManager {
   
    static let sharedInstance = WidgetOrderManager()
    
    private init() {}
    
    enum WidgetOrderErrors: Error {
        case DBFail
        case JSONFail
        case UnknownFail
        case AWBNotFound
    }
    
    func getDHLOrderAsync(awb: String) async throws -> [String] {
        let _headers : HTTPHeaders = ["DHL-API-Key": "demo-key"]
        let params : Parameters = ["trackingNumber" : awb]
        
        let getRequest = AF.request("https://api-test.dhl.com/track/shipments", method: .get, parameters: params, encoding: URLEncoding.default, headers: _headers)
                
        var responseJson: String!
        do {
            responseJson = try await getRequest.serializingString().value
        } catch {
            throw WidgetOrderErrors.DBFail
        }
        
        var shipment: DHLShipment!
        do {
            shipment = try DecodingManager.sharedInstance.decodeDHLJson(jsonString: responseJson).first
        } catch {
            throw WidgetOrderErrors.AWBNotFound
        }
        
        return [String(shipment.status.timestamp.split(separator: "+")[0]).turnToDate().turnToReadableString(), shipment.status.statusCode.capitalized]
    }
    
    func getSamedayOrderAsync(awb: String) async throws -> [String] {
        let params : Parameters = ["_locale" : "en"]
        
        let getRequest = AF.request("https://api.sameday.ro/api/public/awb/\(awb)/awb-history", method: .get, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseJson: String!
        do {
            responseJson = try await getRequest.serializingString().value
        } catch {
            throw WidgetOrderErrors.DBFail
        }
        
        var shipment: SamedayParcelsList!
        do {
            try shipment = DecodingManager.sharedInstance.decodeSamedayJson(jsonString: responseJson)
        } catch {
            throw WidgetOrderErrors.AWBNotFound
        }
        
        return [String(shipment.awbHistory.first!.statusDate.split(separator: "+")[0]).turnToDate().turnToReadableString(), shipment.awbHistory.first!.statusState]
    }
    
    func getCargusOrderAsync(awb: String) async throws -> [String] {
        let params : Parameters = ["t" : awb]
        
        let getRequest = AF.request("https://www.cargus.ro/tracking-romanian", method: .get, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseHtml: String!
        do {
            responseHtml = try await getRequest.serializingString().value
        } catch {
            throw WidgetOrderErrors.DBFail
        }
        
        var cargusShipment: CargusShipment!
        do {
            cargusShipment = try DecodingManager.sharedInstance.decodeCargusHTML(htmlString: responseHtml)
        } catch {
            throw WidgetOrderErrors.AWBNotFound
        }
 
        return [cargusShipment.events.first!.date.turnToDate().turnToReadableString(), cargusShipment.events.first!.status]
    }
    
    func getGLSOrderAsync(awb: String) async throws -> [String] {
        let params : Parameters = ["match" : awb]
        
        let getRequest = AF.request("https://gls-group.com/app/service/open/rest/RO/en/rstt001", method: .get, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseJSON : String!
        do {
            responseJSON = try await getRequest.serializingString().value
        } catch {
            throw WidgetOrderErrors.DBFail
        }
        
        var GLSShipment : GLSPackageStatus
        do {
            GLSShipment = try DecodingManager.sharedInstance.decodeGLSJSON(jsonString: responseJSON)
        } catch {
            throw WidgetOrderErrors.AWBNotFound
        }
        
        let shipment = GLSShipment.tuStatus.first
        
        return ["\(String(describing: shipment?.history.first?.date ?? "DATE"))T\(String(describing: shipment?.history.first?.time ?? "DATE"))".turnToDate().turnToReadableString(), String((shipment?.history.first?.evtDscr.split(separator: "(").first!)!)]
    }
    
    func getDPDOrderAsync(awb: String) async throws -> [String] {
        let params : Parameters = ["shipmentNumber" : awb,
                                   "language" : "en"]
        
        let getRequest = AF.request("https://tracking.dpd.ro/", method: .get, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseHTML : String!
        do {
            responseHTML = try await getRequest.serializingString().value
        } catch {
            throw WidgetOrderErrors.DBFail
        }
        
        var shipment : DPDShipment
        do {
            shipment = try DecodingManager.sharedInstance.decodeDPDHTML(htmlString: responseHTML)
        } catch {
            throw WidgetOrderErrors.AWBNotFound
        }
        
        return [shipment.events.last!.date.turnToDate().turnToReadableString(), shipment.events.last!.status]
    }
    
    func getFanCourierOrderAsync(awb: String) async throws -> [String] {
        let params : Parameters = ["username" : "clienttest",
                                   "user_pass" : "testing",
                                   "client_id" : "7032158",
                                   "AWB" : awb,
                                   "display_mode" : "5",
                                   "language" : "en"]
        let postRequest = AF.request("https://www.selfawb.ro/awb_tracking_integrat.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: .default)
        
        var responseJSON : String!
        do {
            responseJSON = try await postRequest.serializingString().value
        } catch {
            throw WidgetOrderErrors.DBFail
        }
        
        var shipment : FanCourierDelivery
        do {
            shipment = try DecodingManager.sharedInstance.decodeFanCourierJSON(jsonString: responseJSON)
        } catch {
            throw WidgetOrderErrors.AWBNotFound
        }
        
        let dateString = String(shipment.deliverydate.split(separator: ".")[2]) + "-" + String(shipment.deliverydate.split(separator: ".")[1]) + "-" + String(shipment.deliverydate.split(separator: ".")[0]) + "T" + shipment.deliverytime + ":00"
        return [dateString.turnToDate().turnToReadableString(), shipment.status]
    }
}
