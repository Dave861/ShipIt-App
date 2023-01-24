//
//  DeliveryDayPrediction.swift
//  ShipIt
//
//  Created by Mihnea on 1/24/23.
//

import Foundation
import CoreML

class DeliveryDayPrediction {
    let config = MLModelConfiguration()
    
    public func calculateDeliveryDate(distance : Double, completion: @escaping (Double) -> ()) throws {
        do {
            let model = try DeliveryDayPredict(configuration: config)
            try completion(model.prediction(distance: distance).days)
        } catch let error {
            throw error
        }
    }
}
