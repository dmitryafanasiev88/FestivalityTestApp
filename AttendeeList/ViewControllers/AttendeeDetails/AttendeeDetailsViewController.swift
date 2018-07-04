import Foundation
import UIKit

class AttendeeDetailsViewController: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var viewModel = AttendeeDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Details"
    }
    
    func customizeUI() {
        firstNameLabel.text = viewModel.attendee?.firstName ?? "Not specified"
        lastNameLabel.text = viewModel.attendee?.lastName ?? "Not specified"
        genderLabel.text = viewModel.attendee?.gender ?? "Not specified"
        cityLabel.text = viewModel.attendee?.city ?? "Not specified"
        companyLabel.text = viewModel.attendee?.company ?? "Not specified"
        ageLabel.text = viewModel.attendee?.age?.description ?? "Not specified"
    }
}
