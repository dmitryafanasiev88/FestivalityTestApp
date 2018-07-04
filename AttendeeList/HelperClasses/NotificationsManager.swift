import Foundation
import KeychainSwift
import Alamofire
import UserNotifications

/*
 
 A simple apns notifications manager, with minimum required functionality.
 
 NotificationPermittedStatus - custom enum for representing notifications allowance status,
 which helps not to import UserNotifications in all classes, which needs the location authorization status
 
 I do not have valid apns certificate, developer certificate and a provision profile to test the app on the device,
 so I used <testApnsToken> value as token value to be able to perform requests to the server
 
 */

enum NotificationPermittedStatus {
    case allowed
    case denied
    case notRequested
}

class NotificationsHandler {
    static let apnsTokenKey = "APNSToken"
    private let testApnsToken = "03df25c845d460bcdad7802d2vf6fc1dfde97283bf75cc993eb6dca835ea2e2f"
    
    // Variable for handling the device token and provide it for making HTTPHeaders,
    // so there will be no need to fetch the token from the keychain each time
    private(set) var deviceToken: String = ""
    
    init() {
        let keychain = KeychainSwift()
        self.deviceToken = keychain.get(NotificationsHandler.apnsTokenKey) ?? testApnsToken
    }
    
    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                self.getNotificationStatus { (status) in
                    if status == .allowed {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        }
    }
    
    // Retrieve actual notifications allowance status
    // Completion block is required
    func getNotificationStatus(completion: @escaping (NotificationPermittedStatus) -> (Void)) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            var status: NotificationPermittedStatus = .notRequested
            switch settings.authorizationStatus {
            case .denied:
                status = .denied
            case .authorized:
                status = .allowed
            case .notDetermined:
                status = .notRequested
            }
            
            completion(status)
        }
    }
    
    func registerDeviceToken(_ deviceToken: Data) {
        // Parse token
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Token is \(deviceTokenString)");
        
        saveDeviceToken(deviceTokenString)
    }
    
    private func saveDeviceToken(_ token: String) {
        self.deviceToken = token
        
        // Save token
        let keychain = KeychainSwift()
        keychain.set(token, forKey: NotificationsHandler.apnsTokenKey)
    }
    
}
