import Foundation
import CoreLocation

/*
 
 A simple location manager, with minimum required functionality.
 
 LocationManagerAuthorizationStatus - custom enum for representing AuthorizationStatus,
 which helps not to import CoreLocation in all classes, which needs the location authorization status
 
 This manager can only request location authorization (WhenInUse) and get the actual status
 
 */

enum LocationManagerAuthorizationStatus {
    case authorized
    case notRequested
    case denied
}

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getAuthorizationStatus() -> LocationManagerAuthorizationStatus {
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notRequested
        default:
            return .authorized
        }
    }

}
