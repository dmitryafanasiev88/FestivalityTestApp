import Foundation
import UIKit

/*
 
 Decided to use Navigation Controller to handle Intro screen inside instead of PageViewController
 Provided Intro screens (examples) didn't contained page dot indicators, also navigation between them should perform via 'Skip' button pressing as I thought
 that was the reason to choose Navigation Controller flow
 
 I didn't use provided images as background views because of inconsistent behaviour in screen rotation,
 so I just made simple UI for representing intro screens content
 
 All content is provided from the ViewModel
 
 Intro screen do not support Real-Time status handling, but is supposed to check the actual satus each time you start the view controller (restart the app)
 
 */

class IntroPageViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subtitleLabel: UILabel?
    @IBOutlet weak var enableButton: UIButton?
    @IBOutlet weak var skipButton: UIButton?
    
    var viewModel = IntroPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize labels
        let labelsData = viewModel.labelsCustomizationData()
        titleLabel?.text = labelsData.title
        subtitleLabel?.text = labelsData.subtitle
        
        // Customize buttons layer props
        skipButton?.layer.cornerRadius = 8
        skipButton?.layer.borderWidth = 2
        skipButton?.layer.borderColor = UIColor.black.cgColor
        
        enableButton?.layer.cornerRadius = 8
        enableButton?.layer.borderWidth = 2
        enableButton?.layer.borderColor = UIColor.black.cgColor
        
        // Customize buttons in the callback,
        // because NotificationsManager requires callback to get the actual status
        viewModel.getButtonsCustomizationData { [weak self] (actionTitle, skipTitle) in
            print(actionTitle, skipTitle)
            self?.enableButton?.setTitle(actionTitle, for: .normal)
            self?.skipButton?.setTitle(skipTitle, for: .normal)
        }
        
        // In case if there is tha last screen - remove Skip button (it's optional variable because of that)
        if viewModel.introType == .LetsStart {
            self.skipButton?.removeFromSuperview()
        }
    }
    
    @IBAction func enableButtonPressed() {
        switch viewModel.introType {
        case .LetsStart:
            AppDelegate.shared.switchIntroToAttendeeList()
        case .EnableNotification:
            AppDelegate.shared.notificationsHandler.registerForRemoteNotifications()
        case .EnableLocations:
            AppDelegate.shared.locationsManager.requestAuthorization()
        }
    }
    
    @IBAction func skipButtonPressed() {
        if let nextType = viewModel.nextType(),
            let vc = UIApplication.shared.controllerInStoryboard("Main", controllerIdentifier: "IntroPage") as? IntroPageViewController {
            Settings.saveBoolValue(true, forKey: Settings.introPassedKey)
            vc.viewModel = IntroPageViewModel(type: nextType)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
