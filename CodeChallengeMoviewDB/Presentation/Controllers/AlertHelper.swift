import Foundation
import UIKit

final class AlertHelper {
    static func presentAlertError(_ viewController: UIViewController,
                                  message: String,
                                  title: String = NSLocalizedString("error", comment: ""),
                                  buttonTitle: String = NSLocalizedString("ok", comment: "")) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle,
                                      style: .destructive,
                                      handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
