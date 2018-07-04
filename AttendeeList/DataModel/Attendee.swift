import Foundation
import CoreData

protocol AttendeeCustomizationProtocol {
    func customizeWithDictionary(_ dict: [String : Any])
}

open class Attendee: NSManagedObject, AttendeeCustomizationProtocol {
    @NSManaged open var id : NSNumber
    @NSManaged open var firstName : String?
    @NSManaged open var lastName : String?
    @NSManaged open var city: String?
    @NSManaged open var company: String?
    @NSManaged open var gender: String?
    @NSManaged open var age: NSNumber?
    
    func customizeWithDictionary(_ dict: [String : Any]) {
        if let val = dict["age"] as? Int {
            self.age = NSNumber(value: val)
        }
        if let val = dict["firstName"] as? String {
            self.firstName = val
        }
        if let val = dict["lastName"] as? String {
            self.lastName = val
        }
        if let val = dict["gender"] as? String {
            self.gender = val
        }
        if let val = dict["company"] as? String {
            self.company = val
        }
        if let val = dict["city"] as? String {
            self.city = val
        }
    }
    
}

extension Attendee {
    
    @nonobjc static func attendeeWithId(_ id: Int) -> Attendee? {
        return Attendee.attendeeWithIdInContext(id, context: AppDelegate.shared.persistentContainer.viewContext)
    }
    
    @nonobjc static func attendeeWithIdInContext(_ id: Int, context: NSManagedObjectContext) -> Attendee? {
        return Attendee.fetchFromContext(context: context, withPredicate: NSPredicate(format: "id == \(id)"), sortDescriptors: nil)?.first
    }
    
    @nonobjc static func attendeeWithIdOrNewAttendee(_ id: Int) -> Attendee {
        return attendeeWithIdOrNewAttendeeInContext(id, context: AppDelegate.shared.persistentContainer.viewContext)
    }
    
    @nonobjc static func attendeeWithIdOrNewAttendeeInContext(_ id: Int, context: NSManagedObjectContext) -> Attendee {
        let attendee: Attendee = Attendee.attendeeWithIdInContext(id, context: context) ?? context.insertObject()
        attendee.id = NSNumber(value: id)
        return attendee
    }
}
