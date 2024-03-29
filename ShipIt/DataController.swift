import Foundation
import CoreData

class DataController : ObservableObject {
    static let shared = DataController()
    
    public static var persistentContainer: NSPersistentContainer = {
        let storeURL = URL.storeURL(for: "group.ShipIt-dev.savedPackages", databaseName: "Model")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "Model")
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getStoredDataFromCoreDataFromBackground() throws -> [NSManagedObject] {
        let managedContext = DataController.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Package")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error {
            throw error
        }
    }
    
    func getStoredDataFromCoreData() -> [NSManagedObject] {
        let managedContext = DataController.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Package")
        do {
            let result = try managedContext.fetch(fetchRequest)
            //Iterate between all the results saved into EntityName
            return result
        } catch let error as NSError {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return []
    }
    
    func saveContext() {
        let context = DataController.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func returnPackageOnBackgroundThread(managedObject: NSManagedObjectID) throws -> Package {
        do {
            let context = DataController.persistentContainer.viewContext
            return try context.existingObject(with: managedObject) as! Package
        } catch let err {
            throw err
        }
    }
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
