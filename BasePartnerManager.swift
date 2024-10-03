import UIKit
import FaceTecSDK

open class BasePartnerManager {
  
  public var sendDocumentPicture: (() -> Void)?
  public var onNavigateToFaceCapture: (() -> Void)?
  public var waitingFaceTecResponse: (() -> Void)?
        
  public var navigateToStatus: (() -> Void)?
  public var onSuccessFaceTec: (() -> Void)?
  
  public var currentViewController: UIViewController?
  
  public var transaction: String = ""
  public var sessionToken: String = ""
    
    private var documentImageTypeFront: String = ""
    private var documentImageTypeBack: String = ""
    
  public var documentsImages = [[String:Any]]()
  public var documentType: String = ""
  public var documentByte: String = ""
  
  public var wasProcessed: Bool = false
  public var faceScanResultCallback: FaceTecFaceScanResultCallback?
  
  //MARK: - init

  public init() {}
  
  //MARK: - Public Functions
  
  public func initializeSDK(_ viewController: UIViewController) {
    let mainViewModel = ScanViewModel(partnerManager: self)
    viewController.navigationController?.pushViewController(
        ScanViewController(viewModel: mainViewModel), animated: true
    )
  }
  
  public func startDocumentCapture() -> UIViewController {
    let mainViewModel = ScanViewModel(partnerManager: self)
    return ScanViewController(viewModel: mainViewModel, viewTitle: "Frente")
  }
  
  public func transactionId(_ id: String = "") -> String {
    return id
  }
  
  public func sessionToken(_ token: String = "") -> String {
    return token
  }
  
  public func createUserAgentForNewSession() -> String {
    return FaceTec.sdk.createFaceTecAPIUserAgentString("")
  }
  
  public func createUserAgentForSession(_ sessionToken: String = "") -> String {
    return FaceTec.sdk.createFaceTecAPIUserAgentString(sessionToken)
  }
  
  public func setDocumentType(_ type: String) {
    documentType = type
  }
  
  public func getDocumentImageType() -> String {
    return documentType
  }
    public func setDocumentImageTypeFront(_ type: String = "") -> Void {
    documentImageTypeFront = type
    }
    
    public func getDocumentImageTypeBack() -> String {
        return documentImageTypeBack
    }
    public func setDocumentImageTypeBack(_ type: String = "") -> Void {
      documentImageTypeBack = type
    }
  
  public func getDocumentImageSize(_ size: String = "") -> String {
    return size
  }
  
  public func lastViewController(_ viewController: UIViewController = UIViewController()) -> UIViewController {
    return viewController
  }
}
