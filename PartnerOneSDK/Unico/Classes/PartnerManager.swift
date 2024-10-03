import UIKit

open class PartnerManager: BasePartnerManager {
  
  //MARK: - Public Properties
  public static var livenessCallBack: ((_ faceScan:String, _ auditTrailImage:String ,_ lowQualityAuditTrailImage:String) -> Void)?
        
    public static var livenessCancelCallBack: (()-> Void)?
    
  public var faceTecDeviceKeyIdentifier: String = ""
  public var faceTecPublicFaceScanEncryptionKey: String = ""
  public var faceTecProductionKeyText: String = ""
    
    public var configuration: Configuration?
    
//    public var faceScan: String = ""
//    public var auditTrailImage: String = ""
//    public var lowQualityAuditTrailImage: String = ""
    
  public var getFaceScan: String = ""
  public var getAuditTrailImage: String = ""
  public var getLowQualityAuditTrailImage: String = ""
  
  //public var faceScanResultCallback: FaceTecFaceScanResultCallback?
  
  //MARK: - init

  public func startFaceCapture() -> UIViewController {
      let viewController = FacialScanViewController(partnerManager: self, config: configuration)
      
//    let mainViewModel = ScanViewModel(partnerManager: self)
//    let viewController = FacialScanViewController(viewModel: mainViewModel, partnerManager: self)
//    processor?.partnerManager = self
    return viewController
  }
  
//  public func faceScanBase64() -> String {
//    let mainViewModel = ScanViewModel(partnerManager: self)
//    let viewController = FacialScanViewController(viewModel: mainViewModel, partnerManager: self)
//    return viewController.faceScanBase64
//  }
}
