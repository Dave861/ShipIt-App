//
//  Events+CoreDataProperties.swift
//  ShipIt
//
//  Created by Mihnea on 12/29/22.
//
//

import Foundation
import CoreData


extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events")
    }

    @NSManaged public var timestamp: String?
    @NSManaged public var address: String?
    @NSManaged public var text: String?
    @NSManaged public var id: UUID?
    @NSManaged public var systemImage: String?
    @NSManaged public var package: NSSet?
    
    public var packageArray : [Package] {
        let set = package as? Set<Package> ?? []
        
        return set.sorted {
            $0.id <= $1.id
        }
    }
}

// MARK: Generated accessors for package
extension Events {

    @objc(addPackageObject:)
    @NSManaged public func addToPackage(_ value: Package)

    @objc(removePackageObject:)
    @NSManaged public func removeFromPackage(_ value: Package)

    @objc(addPackage:)
    @NSManaged public func addToPackage(_ values: NSSet)

    @objc(removePackage:)
    @NSManaged public func removeFromPackage(_ values: NSSet)

}

extension Events : Identifiable {

}
