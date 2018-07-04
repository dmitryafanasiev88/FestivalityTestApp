import Foundation

/*
 
 Simple view model for representing Atendee Details View Controller
 
 */

class AttendeeDetailsViewModel {
    private(set) var attendee: Attendee?
    
    init() {
        self.attendee = nil
    }
    
    init(_ attendee: Attendee) {
        self.attendee = attendee
    }
    
}
