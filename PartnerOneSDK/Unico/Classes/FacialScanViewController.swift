
import AcessoBio

public struct Configuration: Decodable {
    let hostInfo: String?
    let hostKey: String?
    let bundleIdentifier: String?
    let mobilesdkAppId: String?
    let projectId: String?
    let projectNumber: String?
}

public class FacialScanViewController: UIViewController {
    
    private let partnerManager: PartnerManager
    private let config: Configuration?
    private var manager: AcessoBioManager?
    
    init(
        partnerManager: PartnerManager,
        config: Configuration?
    ) {
        self.partnerManager = partnerManager
        self.config = config
        
        super.init(nibName: nil, bundle: nil)
        
        start()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configureSelfieCamera() {
        let smartCamera = true
        manager?.setSmartFrame(smartCamera)
        manager?.setAutoCapture(smartCamera)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    private func start() {
        
        manager = AcessoBioManager(viewController: self)
        manager?.setTheme(SampleAppThemes())
        
        configureSelfieCamera()
        manager?.build().prepareSelfieCamera(
            self,
            config: SDKConfig(configuration: config)
        )
    }
}

extension FacialScanViewController: AcessoBioCameraDelegate {
    public func prepareSelfieCamera(_ delegate: (any SelfieCameraDelegate)!, jsonConfigName: String!) { }
    
    public func prepareSelfieCamera(_ delegate: (any SelfieCameraDelegate)!, jsonConfigName: String!, bundle: Bundle!) { }
    
    public func prepareSelfieCamera(_ delegate: (any SelfieCameraDelegate)!, config: (any AcessoBio.AcessoBioConfigDataSource)!) { }
    
    public func prepareDocumentCamera(_ delegate: (any DocumentCameraDelegate)!, jsonConfigName: String!) { }
    
    public func prepareDocumentCamera(_ delegate: (any DocumentCameraDelegate)!, jsonConfigName: String!, bundle: Bundle!) { }
    
    public func prepareDocumentCamera(_ delegate: (any DocumentCameraDelegate)!, config: (any AcessoBio.AcessoBioConfigDataSource)!) { }
}

// MARK: - AcessoBioManagerDelegate

extension FacialScanViewController: AcessoBioManagerDelegate {
    public func onErrorAcessoBioManager(_ error: ErrorBio!) {
        print("\(#fileID) > \(#function) > \(error.code)")
        
        PartnerManager.livenessCancelCallBack?()
    }
    
    public func onUserClosedCameraManually() {
        print("\(#fileID) > \(#function)")
        
        PartnerManager.livenessCancelCallBack?()
    }
    
    public func onSystemClosedCameraTimeoutSession() {
        print("\(#fileID) > \(#function)")
    }
    
    public func onSystemChangedTypeCameraTimeoutFaceInference() {
        print("\(#fileID) > \(#function)")
    }
}

extension FacialScanViewController: SelfieCameraDelegate {
    public func onCameraReady(_ cameraOpener: AcessoBioCameraOpenerDelegate!) {
        print("\(#fileID) > \(#function)")
        cameraOpener.open(self)
    }
    
    public func onCameraFailed(_ message: ErrorPrepare!) {
        print("\(#fileID) > \(#function) > \(message.desc)")
        
        PartnerManager.livenessCancelCallBack?()
    }
}

// MARK: - AcessoBioSelfieDelegate
extension FacialScanViewController: AcessoBioSelfieDelegate {
    public func onSuccessSelfie(_ result: AcessoBio.SelfieResult!) {
        PartnerManager.livenessCallBack!(result.encrypted + "/u", result.base64, "")
    }
    
    public func onErrorSelfie(_ errorBio: ErrorBio!) {
        print("\(#fileID) > \(#function) > \(errorBio.code)")
    }
}

////
///
final class SDKConfig: AcessoBioConfigDataSource {
    
    let configuration: Configuration?
    init(configuration: Configuration?) {
        self.configuration = configuration
    }
    
    func getProjectNumber() -> String { configuration?.projectNumber ?? "" }

    func getProjectId() -> String { configuration?.projectId ?? ""}

    func getMobileSdkAppId() -> String { configuration?.mobilesdkAppId ?? "" }

    func getBundleIdentifier() -> String { "com.projeto.projetoexemplo"}

    func getHostInfo() -> String { configuration?.hostInfo ?? "" }
    
    func getHostKey() -> String { configuration?.hostKey ?? ""}
}

final class SampleAppThemes: AcessoBioThemeDelegate {
    func getColorBackground() -> Any! {
        UIColor.white
    }
    
    func getColorBoxMessage() -> Any! {
        UIColor.red
    }
    
    func getColorTextMessage() -> Any! {
        UIColor.blue
    }
    
    func getColorBackgroundPopupError() -> Any! {
        UIColor.brown
    }
    
    func getColorTextPopupError() -> Any! {
        UIColor.cyan
    }
    
    func getColorBackgroundButtonPopupError() -> Any! {
        UIColor.darkGray
    }
    
    func getColorTextButtonPopupError() -> Any! {
        UIColor.purple
    }
    
    func getColorBackgroundTakePictureButton() -> Any! {
        UIColor.orange
    }
    
    func getColorIconTakePictureButton() -> Any! {
        UIColor.green
    }
    
    func getColorBackgroundBottomDocument() -> Any! {
        UIColor.magenta
    }
    
    func getColorTextBottomDocument() -> Any! {
        UIColor.gray
    }
    
    func getColorSilhouetteSuccess() -> Any! {
        UIColor.magenta
    }
    
    func getColorSilhouetteError() -> Any! {
        UIColor.orange
    }
    
    func getColorSilhouetteNeutral() -> Any! {
        UIColor.red
    }
}
