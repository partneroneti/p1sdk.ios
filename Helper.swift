import UIKit
import FaceTecSDK

protocol PartnerHelperProtocol: AnyObject {
  var mainViewController: UIViewController { get }
  var transactionID: String { get }
}

open class PartnerHelper: PartnerHelperProtocol {
  
  //MARK: - Public Properties
  
  public var mainViewController = UIViewController()
  public var transactionID: String = ""
  
  //MARK: - init

  public init(mainViewController: UIViewController = UIViewController(),
              transactionID: String = "") {
    self.mainViewController = mainViewController
    self.transactionID = transactionID
  }
  
  //MARK: - Public Functions
  
  public func initializeSDK(_ viewController: UIViewController) {
    let mainWorker = PartnerOneWorker()
    let mainViewModel = ScanViewModel(worker: mainWorker)
    let mainViewController = ScanViewController(viewModel: mainViewModel)
    viewController.navigationController?.pushViewController(mainViewController, animated: true)
  }
  
  public func openViewAfter(_ viewController: UIViewController) {
    viewController.navigationController?.popToViewController(mainViewController, animated: true)
  }
  
  public func createUserAgentForNewSession() -> String {
    return ""
  }
  
  public func faceTecDeviceKeyIdentifier(_ clientKey: String = "") -> String {
    return clientKey
  }
  
  public func faceTecBaseURL(_ url: String = "") -> String {
    return url
  }
  
  public func faceTecPublicFaceScanEncryptionKey(_ key: String = "") -> String {
    return key
  }
  
  public func faceTecProductionKeyText(_ key: String = "") -> String {
    return key
  }
}
