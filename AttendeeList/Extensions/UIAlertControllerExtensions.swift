import Foundation
import UIKit

/*
 
 Used to show Sorting Alert
 
 */

extension UIAlertController {
    
    @nonobjc class func showActionSheetWithButtonTitles(buttonTitles:[String],
                                                        inViewController viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController,
                                                        completionHandler: @escaping (_ selectedButtonIndex: Int?) -> ()) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for (index, title) in buttonTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default) { _ in
                completionHandler(index)
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(nil)
        })
        
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
}
