import Foundation
import UIKit

protocol AttendeeCellCustomizationProtocol {
    func customizeCellWithAttendee(_ attendee: Attendee?, _ order: Int)
}

/*
 
 Cell for representing Attendee object in the Attendee List
 
 */

class AttendeeListCell: UITableViewCell, AttendeeCellCustomizationProtocol {
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        customizeCellWithAttendee(nil, 0)
    }
    
    func customizeCellWithAttendee(_ attendee: Attendee?, _ order: Int) {
        nameLabel.text = "\(attendee?.firstName ?? "-") \(attendee?.lastName ?? "-")"
        if let age = attendee?.age {
            ageLabel.text = "\(age.description) years old"
        } else {
            ageLabel.text = ""
        }
        companyLabel.text = "\(attendee?.company ?? "")"
        orderLabel.text = "\(order)"
    }
    
}

// Basicly this should be an extension for UIView, but here it's used only for that cell, thats why it's extension for a AttendeeListCell

extension AttendeeListCell {
    
    @nonobjc static var defaultReuseIdentifier : String {
        return String(describing: self)
    }
}
