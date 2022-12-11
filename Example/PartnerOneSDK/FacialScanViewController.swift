import UIKit
import FaceTecSDK

final class FacialScanViewController: UIViewController, FaceTecFaceScanProcessorDelegate, URLSessionDelegate {
  
  //MARK: - Properties
  
  var viewModel: ScanViewModel
  weak var helper = PartnerHelper()
  
  private var latestExternalDatabaseRefID: String = ""
  private var latestSessionResult: FaceTecSessionResult!
  private var latestIDScanResult: FaceTecIDScanResult!
  private var latestProcessor: Processor!
  private var utils: SampleAppUtilities?
  
  //MARK: - init
  
  init(viewModel: ScanViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    FaceTec.initialize()
    setupFaceTec()
  }
}

//MARK: - Private Functions

extension FacialScanViewController {
  func setupFaceTec() {
    FaceTec.sdk.initializeInDevelopmentMode(deviceKeyIdentifier: "",
                                            faceScanEncryptionKey: "")
    Config.initializeFaceTecSDKFromAutogeneratedConfig(completion: { initializationSuccessful in
      Config.displayLogs()
      self.initializeProcessor()
      
      Config.ProductionKeyText = self.helper?.faceTecProductionKeyText ?? ""
      Config.DeviceKeyIdentifier = self.helper?.faceTecDeviceKeyIdentifier ?? ""
      Config.PublicFaceScanEncryptionKey = self.helper?.faceTecPublicFaceScanEncryptionKey ?? ""
    })
  }
  
  func processSessionWhileFaceTecSDKWaits(sessionResult: FaceTecSessionResult,
                                          faceScanResultCallback: FaceTecFaceScanResultCallback) {}
  
  func onFaceTecSDKCompletelyDone() {}
  
  func onComplete() {
    print("Escaneamento Completo. Navegando para Status!")
    PartnerHelper().navigateToStatus?()
  }
  
  func getLatestExternalDatabaseRefID() -> String {
      return latestExternalDatabaseRefID;
  }
  
  func setLatestSessionResult(sessionResult: FaceTecSessionResult) {
      latestSessionResult = sessionResult
  }
  
  func initializeProcessor() -> Processor {
    return LivenessCheckProcessor(sessionToken: helper?.sessionToken() ?? "", fromViewController: self)
  }
  
  public func createUserAgentForNewSession() -> String {
    return FaceTec.sdk.createFaceTecAPIUserAgentString("")
  }
  
  public func createUserAgentForSession(_ sessionId: String) -> String {
    return FaceTec.sdk.createFaceTecAPIUserAgentString(sessionId)
  }
}
