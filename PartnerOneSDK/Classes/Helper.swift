import UIKit

protocol PartnerHelperProtocol: AnyObject {
  var mainViewController: UIViewController { get }
  var transactionID: String { get }
}

public class PartnerHelper: PartnerHelperProtocol {
  
  public var mainViewController = UIViewController()
  public var transactionID: String = ""
  
  public func openViewAfter(_ viewController: UIViewController) {
    viewController.navigationController?.popToViewController(mainViewController, animated: true)
  }
}
