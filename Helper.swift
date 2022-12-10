import UIKit
import FaceTecSDK

open class PartnerHelper {
  
  //MARK: - Public Properties
  
  private let mainWorker = PartnerOneWorker()
  private let mainViewModel = ScanViewModel()
  
  public var sendDocumentPicture: (() -> Void)?
  public var getSessionToken: (() -> Void)?
  public var transactionID: String = ""
  
  //MARK: - init

  public init(transactionID: String = "") {
    self.transactionID = transactionID
  }
  
  //MARK: - Public Functions
  
  public func initializeSDK(_ viewController: UIViewController) {
    viewController.navigationController?.pushViewController(ScanViewController(viewModel: mainViewModel), animated: true)
  }
  
  public func startFaceCapture() -> UIViewController {
    return ScanViewController(viewModel: mainViewModel)
  }
  
  public func startDocumentCapture() -> UIViewController {
    return FacialScanViewController(viewModel: mainViewModel)
  }
  
  public func sessionToken(_ token: String) -> String {
    return token
  }
  
  public func createUserAgentForNewSession() -> String {
    return ""
  }
  
  public func createUserAgentForSession(_ sessionId: String) -> String {
    return sessionId
  }
  
  public func faceTecDeviceKeyIdentifier(_ clientKey: String = "") -> String {
    return clientKey
  }
  
  public func faceTecPublicFaceScanEncryptionKey(_ key: String = "") -> String {
    return key
  }
  
  public func faceTecProductionKeyText(_ key: String = "") -> String {
    return key
  }
}
