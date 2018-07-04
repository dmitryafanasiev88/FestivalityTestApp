import CoreData

/*
 
 Helper extensions for NSManagedObject
 
 */

extension NSManagedObject {
    
    @nonobjc static var entityName : String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    
    // Create an instance of NSManagedObject as NSManagedObject()
    convenience init(managedObjectContext: NSManagedObjectContext) {
        let entityName = type(of: self).entityName
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
    }
    
    // MARK: - Fetch requests from default context (main context)
    
    @nonobjc static func fetchRequestFromDefaultContext() -> NSFetchRequest<NSFetchRequestResult> {
        return fetchRequestFromDefaultContextWithPredicate(nil)
    }
    
    @nonobjc static func fetchRequestFromDefaultContextWithPredicate(_ predicate: NSPredicate?) -> NSFetchRequest<NSFetchRequestResult> {
        return fetchRequestFromDefaultContextWithPredicate(predicate, sortDescriptors: nil)
    }
    
    @nonobjc static func fetchRequestFromDefaultContextWithPredicate(_ predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 100
        fetchRequest.sortDescriptors = sortDescriptors ?? [NSSortDescriptor(key: "id", ascending: true)]
        return fetchRequest
    }
    
    // MARK:- Fetch from default context
    
    @nonobjc static func fetchFromDefaultContext<T: NSManagedObject>() -> [T]? {
        return fetchFromDefaultContext(withPredicate: nil)
    }
    
    @nonobjc static func fetchFromDefaultContext<T: NSManagedObject>(withPredicate predicate: NSPredicate?) -> [T]? {
        return fetchFromDefaultContext(withPredicate: predicate, sortDescriptors: nil)
    }
    
    @nonobjc static func fetchFromDefaultContext<T: NSManagedObject>(withPredicate predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]? {
        let context = AppDelegate.shared.persistentContainer.viewContext
        return fetchFromContext(context: context, withPredicate: predicate, sortDescriptors: sortDescriptors)
    }
    
    // MARK:- Fetch from given context
    
    @nonobjc static func fetchFromContext<T: NSManagedObject>(context: NSManagedObjectContext, withPredicate predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors ?? [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let results = try context.fetch(fetchRequest)
            if let managedObjects = results as? [T] {
                return managedObjects
            } else {
                print("fetchFromDefaultContext for \(entityName) didn't found valid objects in the context")
                return nil
            }
        } catch {
            print("fetchFromDefaultContext for \(entityName) failed")
            return nil
        }
    }
    
}
