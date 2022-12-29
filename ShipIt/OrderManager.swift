//
//  OrderManager.swift
//  ShipIt
//
//  Created by Mihnea on 12/29/22.
//

import Foundation
import CoreData
import UIKit

struct OrderProcessingResults {
    let status : String
    let timestamp : String
    let address : String
}

class OrderManager {
    
    public func getDHLOrder(package : Package) {
        var status = ""
        var timestamp = ""
        var address = ""
        
        let headers = ["DHL-API-Key": "demo-key"]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api-test.dhl.com/track/shipments?trackingNumber=" + package.awb!)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let printData = String(bytes: data!, encoding: String.Encoding.utf8)
                print(printData!)
                
                status = printData!.slice(from: "statusCode", to: ",") ?? ""
                
                status = status.replacingOccurrences(of: "\"", with: "")
                status = status.replacingOccurrences(of: ":", with: "")
                print(status.capitalized)
                
                timestamp = printData!.slice(from: "timestamp\":\"", to: "T") ?? ""
                
                timestamp = timestamp.replacingOccurrences(of: "\"", with: "")
                timestamp = timestamp.replacingOccurrences(of: "-", with: "/")
                print(timestamp)
                
                address = printData!.slice(from: "\"location\":{\"address\":{\"addressLocality\":\"", to: "\"}") ?? ""
                
                print(address)
                
                package.lastDate = timestamp
                package.statusText = status.capitalized
                package.address = address
                
                let httpResponse = response as? HTTPURLResponse
                package.httpResponse = Int64(exactly: httpResponse!.statusCode)!
                package.codedData = printData!
            }
        })
        dataTask.resume()
    }
}
