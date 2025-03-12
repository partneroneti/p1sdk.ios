import UIKit

open class PartnerManager: BasePartnerManager {
  
  //MARK: - Public Properties
  public static var livenessCallBack: ((_ faceScan:String, _ auditTrailImage:String ,_ lowQualityAuditTrailImage:String) -> Void)?
        
    public static var livenessCancelCallBack: (()-> Void)?
    
    public var faceTecDeviceKeyIdentifier: String = ""
    public var faceTecPublicFaceScanEncryptionKey: String = ""
    public var faceTecProductionKeyText: String = ""

    public var certificate: String = "" {
        didSet {
            guard let decodedData = Data(base64Encoded: certificate) else { return }
            let decoder = JSONDecoder()
            let parsedData = try! decoder.decode(Configuration.self, from: decodedData)
            configuration = parsedData
        }
    }

    private var configuration: Configuration?
    
    public var getFaceScan: String = ""
    public var getAuditTrailImage: String = ""
    public var getLowQualityAuditTrailImage: String = ""

    public func startFaceCapture() -> UIViewController {
      let viewController = FacialScanViewController(partnerManager: self, config: configuration)
    return viewController
    }
}
