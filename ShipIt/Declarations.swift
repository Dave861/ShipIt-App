import Foundation

struct DeliveryStatus {
    var systemImage: String
    var statusText: String
    var lastDate: String
}

struct Order {
    var awb : String
    var link : String
    var status : DeliveryStatus
}
