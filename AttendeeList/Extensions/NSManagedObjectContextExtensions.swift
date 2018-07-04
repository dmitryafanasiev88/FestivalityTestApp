import CoreData

/*
 
 Helper extensions for NSManagedObjectContext
 
 */

extension NSManagedObjectContext {
    
    public func insertObject<T: NSManagedObject>() -> T {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T else {
            fatalError("Invalid Core Data Model.")
        }
        return object
    }
    
}
