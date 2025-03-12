
import UIKit

public extension UIViewController {
    
    func showModal(title: String, message: String) {
     
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (nil) in
            alert.dismiss(animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
