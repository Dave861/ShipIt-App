import Foundation
import CoreData
import MapKit

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

struct Marker : Identifiable{
    var id = UUID()
    var latitude, longitude: Double
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var systemImage: String
    var address : String
}

let userDefaultsClipboardKey = "com.ShipIt.prefences.detectClipboard"
let userDefaultsNotificationsBeforeDeliveryKey = "com.ShipIt.prefences.notificationsBeforeDelivery"
let userdefaultsLiveActivityKey = "com.ShipIt.preferences.showPackagesInLiveActivity"
let userDefaultsLastRefreshKey = "come.ShipIt.lastRefresh"
