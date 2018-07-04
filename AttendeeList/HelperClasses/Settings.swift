import Foundation

/*
 
 This class handles saved objects in UserDefaults.
 
 Now supports only saving/retrieving Bool values
 
 */

class Settings {
    static let introPassedKey = "AttendeeList.IntroPassed"
    
    class func boolValueForKey(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func saveBoolValue(_ value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    class func registerUserDefaults() {
        var defaultsDict = [String : Any]()
        
        // Intro Settings
        defaultsDict[Settings.introPassedKey] = false
        
        UserDefaults.standard.register(defaults: defaultsDict)
    }
    
}
