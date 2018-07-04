import UIKit

/*
 
 Helper extensions for UIApplication
 
 */

extension UIApplication {
    
    
    // Create a ViewController from given StoryboardName and ViewControllerIdentifier in that storyboard
    // Method can put created ViewController inside navigation controller
    func controllerInStoryboard(_ storyboardName: String, controllerIdentifier: String, insideNavigationController: Bool = false, navigationBarHidden: Bool = false) -> UIViewController {
        let storyboard = UIStoryboard(name:storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: controllerIdentifier)
        if insideNavigationController {
            let navigation = UINavigationController(rootViewController: controller)
            navigation.isNavigationBarHidden = navigationBarHidden
            return navigation
        } else {
            return controller
        }
    }
    
}
