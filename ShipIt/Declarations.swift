import Foundation
import CoreData

struct DeliveryStatus {
    var systemImage: String
    var statusText: String
    var lastDate: String
}

struct Order {
    var id = UUID()
    var awb : String
    var link : String
    var status : DeliveryStatus
}
