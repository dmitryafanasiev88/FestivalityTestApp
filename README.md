# FestivalityTestApp

- App is made to run on iOS devices with iOS11 or higher.
- Language used - Swift 4
- App will suggest the user to enable Push Notifications, Location tracking When In use.
- For handling data locally app uses CoreData (data from the server), UserDefaults (local server-independent data), Keychain     (device token handling)

# Installation Steps

1. Ensure you have cocoapods and XCode installed. If no, follow this guide https://cocoapods.org/
2. Open Terminal. 'cd' to projects directory and run 'pod install'
3. After pods installation finishes, open .xcworkspace file with XCode
4. Select any Emulator with iOS 11+ version and Run the project.
    or
   Setup the project with your developers certificate, provision profile and apns certificate 
   (change app bundle_id appropriately if needed) and Run the app on your device.

# Dependencies Used

All used 3-rd party dependencies can be viewed in Pods file. These are the following:
1. Alamofire (https://github.com/Alamofire/Alamofire)
    - used for networking
    - Alamofire is released under the MIT license (https://github.com/Alamofire/Alamofire/blob/master/LICENSE)
2. KeychainSwift (https://github.com/evgenyneu/keychain-swift)
    - used for saving device apns token
    - KeychainSwift is released under the MIT license (https://github.com/evgenyneu/keychain-swift/blob/master/LICENSE)
