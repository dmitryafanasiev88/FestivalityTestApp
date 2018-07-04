import Foundation
import Alamofire
import CoreData

enum AttendeeListSortType: Int {
    case id = 0
    case nameAscending = 1
    case nameDescending = 2
    case companyAscending = 3
    case companyDescending = 4
    
    var sortTitle: String {
        switch self {
        case .nameAscending:
            return "Name Ascending"
        case .nameDescending:
            return "Name Descending"
        case .companyAscending:
            return "Company Name Ascending"
        case .companyDescending:
            return "Company Name Descending"
        case .id:
            return "Default"
        }
    }
    
    var sortDescriptorValues: (value: String, ascending: Bool) {
        switch self {
        case .nameAscending:
            return ("firstName", true)
        case .nameDescending:
            return ("firstName", false)
        case .companyAscending:
            return ("company", true)
        case .companyDescending:
            return ("company", false)
        case .id:
            return ("id", true)
        }
    }
}

class AttendeeListViewModel {
    
    // Notify View Controller about changes on dowloading attendee list status
    var attendeesDownloaded: (() -> (Void))?
    
    // Notify View Controller about changes on sorting type
    var attendeeListSortTypeDidChange: (() -> (Void))?
    var attendeeListSortType: AttendeeListSortType = .id {
        didSet {
            if oldValue != attendeeListSortType {
                attendeeListSortTypeDidChange?()
            }
        }
    }
    
    // Notifu Vie Controller about changes in search bar
    var filterTextHasChanged: (() -> (Void))?
    var filterText: String? {
        didSet {
            filterTextHasChanged?()
        }
    }
    
    // get button titles for Sorting Alert view controller
    var sortTitles: [String] {
        get {
            var result = [String]()
            for i in 0...4 {
                result.append(AttendeeListSortType(rawValue: i)!.sortTitle)
            }
            return result
        }
    }
    
    func retrieveAttendeeList() {
        let headers = AppDelegate.shared.publicHeaders
        
        AppDelegate.HTTPManager.request("https://api.festivality.co/v2/user-list", encoding: JSONEncoding.default, headers: headers)
            .responseJSON { [unowned self] response in
                if response.result.isSuccess {
                    if let JSON = response.result.value as? [String:Any],
                        let resultArray = JSON["response"] as? Array<[String:Any]> {
                        self.saveAttendees(objects: resultArray)
                    } else {
                        self.attendeesDownloaded?()
                    }
                } else {
                    self.attendeesDownloaded?()
                }
        }
    }
    
    // Save downloaded attendees
    // I've made a separate method for this for better readability
    // and according to SOLID principles
    // Take into account that parameters, passed into this method are copied, but for that case
    // parameters count is below 4000, so I think it's ok for this case
    func saveAttendees(objects: Array<[String:Any]>) {
        AppDelegate.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            // Counter variable for test representation
            // to see the progress of objects creation in background
            var counter = 0
            
            for data in objects {
                if let customFields = data["customFields"] as? [String: Any], let id = data["id"] as? Int {
                    let attendee = Attendee.attendeeWithIdOrNewAttendeeInContext(id, context: backgroundContext)
                    attendee.customizeWithDictionary(customFields)
                    counter += 1
                    if counter % 100 == 0 {
                        print("------ Attendees: \(counter) -----")
                    }
                }
            }
            print("------ Attendees: \(counter) -----")
            do {
                try backgroundContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error saving BG Context \(nserror), \(nserror.userInfo)")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.attendeesDownloaded?()
            }
        }
    }
    
}
