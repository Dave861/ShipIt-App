//
//  Package+CoreDataProperties.swift
//  ShipIt
//
//  Created by Mihnea on 12/29/22.
//
//

import Foundation
import CoreData


extension Package {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Package> {
        return NSFetchRequest<Package>(entityName: "Package")
    }

    @NSManaged public var awb: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastDate: String?
    @NSManaged public var link: String?
    @NSManaged public var name: String?
    @NSManaged public var statusText: String?
    @NSManaged public var systemImage: String?
    @NSManaged public var courier: String?
    @NSManaged public var address: String?
    @NSManaged public var httpResponse: Int64
    @NSManaged public var codedData: String?
    @NSManaged public var events: NSSet?
    @NSManaged public var notifications : Bool
    
    public var eventsArray : [Events] {
        let set = events as? Set<Events> ?? []
        
        return set.sorted {
            $0.timestamp!.turnToDate() >= $1.timestamp!.turnToDate()
        }
    }

}

// MARK: Generated accessors for events
extension Package {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Events)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Events)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension Package : Identifiable {

}
