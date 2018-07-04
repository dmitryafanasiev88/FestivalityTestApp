import UIKit
import CoreData
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // Static var for possibility to change the framework for making http
    static var HTTPManager : Alamofire.SessionManager = {
        return Alamofire.SessionManager()
    }()
    
    var window: UIWindow?
    fileprivate(set) var notificationsHandler = NotificationsHandler()
    fileprivate(set) var locationsManager = LocationManager()
    var publicHeaders: HTTPHeaders {
        get {
            let deviceId = UIDevice.current.identifierForVendor?.description ?? "empty"
            let apiClientInfo = "{\"apiClientId\":\"testing-account-cli\",\"apiToken\":\"$2y$10$C/quaRQUsrWa30hjQJuckOXbW9kIZ.W3G1TlLMYg6lr/XDUes7SM.\"}"
            let deviceInfo = "{\"deviceId\":\"\(deviceId)\",\"pushToken\":\"\(notificationsHandler.deviceToken)\"}"
            
            return ["x-apiclient": apiClientInfo, "x-header-request": deviceInfo]
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Settings.registerUserDefaults()
        
        // Create an empty root view controller to support multiple flows like Intro, Login, Main and so on
        // Such root view controller allows to switch between flows easily with animations
        let rootController = UIApplication.shared.controllerInStoryboard("Main",
                                                                         controllerIdentifier: "MainController",
                                                                         insideNavigationController: false,
                                                                         navigationBarHidden: true)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        
        // Create appropriate flow according to passed intro value
        let introPassed = Settings.boolValueForKey(Settings.introPassedKey)
        
        if introPassed {
            showAttendeeListScreen(animated: false)
        } else {
            showIntroScreen()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationsHandler.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for APNS \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AttendeeList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Screen handling
    
    func switchIntroToAttendeeList() {
        if let top = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            top.presentingViewController?.dismiss(animated: true, completion: { [unowned self] in
                self.showAttendeeListScreen(animated: true)
            })
        }
    }
    
    func showAttendeeListScreen(animated: Bool) {
        let vc = UIApplication.shared.controllerInStoryboard("Main", controllerIdentifier: "AttendeeListViewController", insideNavigationController: true)
        window?.rootViewController?.present(vc, animated: animated, completion: nil)
    }
    
    func showIntroScreen() {
        if let vc = UIApplication.shared.controllerInStoryboard("Main", controllerIdentifier: "IntroPage") as? IntroPageViewController {
            vc.viewModel = IntroPageViewModel(type: .EnableNotification)
            let navigation = UINavigationController(rootViewController: vc)
            navigation.isNavigationBarHidden = true
            window?.rootViewController?.present(navigation, animated: false, completion: nil)
        }
    }

}

