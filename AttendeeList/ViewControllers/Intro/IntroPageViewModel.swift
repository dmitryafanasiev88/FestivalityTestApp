import Foundation

/*
 
 ViewModel to provide required data for Intro ViewControllers
 
 */

enum IntroControllerType: Int {
    case EnableNotification
    case EnableLocations
    case LetsStart
}

class IntroPageViewModel {
    var introType: IntroControllerType = .EnableNotification
    
    // Default value
    init() {
        introType = .EnableNotification
    }
    
    init(type: IntroControllerType) {
        introType = type
    }
    
    func nextType() -> IntroControllerType? {
        switch introType {
        case .EnableNotification:
            return .EnableLocations
        case .EnableLocations:
            return .LetsStart
        default:
            return nil
        }
    }
    
    func labelsCustomizationData() -> (title: String, subtitle: String) {
        var title = ""
        var subtitle = ""
        
        switch introType {
            
        case .EnableLocations:
            title = "Enable Smart Location Awareness to work for you."
            subtitle = "Get guidance and utility from app via location directions, navigation and helpful on-site notifications."
            
        case .EnableNotification:
            title = "Get up-to-the-minute updates."
            subtitle = "Allow festival to send you important notifications like program changes, schedule and venue updates."
            
        case .LetsStart:
            title = "Get Started Now!"
            
        }
        
        return (title, subtitle)
    }
    
    func getButtonsCustomizationData(completion: @escaping (_ actionTitle: String, _ skipTitle: String) -> (Void)) {
        var skipTitle = "Skip"
        var actionTitle = ""
        
        switch introType {
            
        case .EnableLocations:
            switch AppDelegate.shared.locationsManager.getAuthorizationStatus() {
            case .notRequested:
                actionTitle = "Enable Location"
            case .denied:
                actionTitle = "Enable from Settings"
            case .authorized:
                actionTitle = "Enabled"
            }
            
            completion(actionTitle, skipTitle)
            
        case .EnableNotification:
            AppDelegate.shared.notificationsHandler.getNotificationStatus { (status) in
                DispatchQueue.main.async {
                    let skipTitle = "Skip"
                    var actionTitle = ""
                    
                    switch status {
                    case .allowed:
                        actionTitle = "Enabled"
                    case .denied:
                        actionTitle = "Enable from Settings"
                    case .notRequested:
                        actionTitle = "Enable Notifications"
                    }
                    
                    completion(actionTitle, skipTitle)
                }
            }
            
        case .LetsStart:
            actionTitle = "Get Started Now!"
            skipTitle = ""
            completion(actionTitle, skipTitle)
        }
    }
    
}
