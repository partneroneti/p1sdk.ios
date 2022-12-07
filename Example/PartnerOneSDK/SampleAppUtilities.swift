import Foundation
import UIKit
import FaceTecSDK
import AVFoundation

class SampleAppUtilities: NSObject, FaceTecCustomAnimationDelegate {
    enum SampleAppVocalGuidanceMode {
        case OFF
        case MINIMAL
        case FULL
    }
    
    var vocalGuidanceOnPlayer: AVAudioPlayer!
    var vocalGuidanceOffPlayer: AVAudioPlayer!
    static var sampleAppVocalGuidanceMode: SampleAppVocalGuidanceMode!
    
    // Reference to app's main view controller
    let sampleAppVC: ScanViewController!
    
    var currentTheme = Config.wasSDKConfiguredWithConfigWizard ? "Config Wizard Theme" : "FaceTec Theme"
    var themeTransitionTextTimer: Timer!
    
    var networkIssueDetected = false
    
    init(vc: ScanViewController) {
        sampleAppVC = vc
    }
    
    func startSessionTokenConnectionTextTimer() {
        themeTransitionTextTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showSessionTokenConnectionText), userInfo: nil, repeats: false)
    }
    
    @objc func showSessionTokenConnectionText() {
        UIView.animate(withDuration: 0.6) {
//            self.sampleAppVC.themeTransitionText.alpha = 1
        }
    }

    func hideSessionTokenConnectionText() {
        themeTransitionTextTimer.invalidate()
        themeTransitionTextTimer = nil
        UIView.animate(withDuration: 0.6) {
//            self.sampleAppVC.themeTransitionText.alpha = 0
        }
    }
    
    func handleErrorGettingServerSessionToken() {
        networkIssueDetected = true
      hideSessionTokenConnectionText();
    }
    
    func showThemeSelectionMenu() {
        let themeSelectionMenu = UIAlertController(title: nil, message: "Select a Theme", preferredStyle: .actionSheet)
        
        let selectDefaultThemeAction = UIAlertAction(title: "FaceTec Theme", style: .default) {
            (_) -> Void in self.handleThemeSelection(theme: "FaceTec Theme")
        }
        if(Config.wasSDKConfiguredWithConfigWizard == true) {
            let selectDevConfigThemeAction = UIAlertAction(title: "Config Wizard Theme", style: .default) {
                (_) -> Void in self.handleThemeSelection(theme: "Config Wizard Theme")
            }
            themeSelectionMenu.addAction(selectDevConfigThemeAction)
        }
        let selectPseudoFullscreenThemeAction = UIAlertAction(title: "Pseudo-Fullscreen", style: .default) {
            (_) -> Void in self.handleThemeSelection(theme: "Pseudo-Fullscreen")
        }
        let selectWellRoundedThemeAction = UIAlertAction(title: "Well-Rounded", style: .default) {
            (_) -> Void in self.handleThemeSelection(theme: "Well-Rounded")
        }
        let selectBitcoinExchangeThemeAction = UIAlertAction(title: "Bitcoin Exchange", style: .default) {
            (_) -> Void in self.handleThemeSelection(theme: "Bitcoin Exchange")
        }
        let selectSampleBankThemeAction = UIAlertAction(title: "Sample Bank", style: .default) {
            (_) -> Void in self.handleThemeSelection(theme: "Sample Bank")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        themeSelectionMenu.addAction(selectDefaultThemeAction)
        themeSelectionMenu.addAction(selectPseudoFullscreenThemeAction)
        themeSelectionMenu.addAction(selectWellRoundedThemeAction)
        themeSelectionMenu.addAction(selectBitcoinExchangeThemeAction)
        themeSelectionMenu.addAction(selectSampleBankThemeAction)
        themeSelectionMenu.addAction(cancelAction)
        // Must use popover controller for iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = themeSelectionMenu.popoverPresentationController {
                popoverController.sourceView = sampleAppVC.view
                popoverController.sourceRect = CGRect(x: sampleAppVC.view.bounds.midX, y: sampleAppVC.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        // Remove negative width constraint that causes layout conflict warning -- non-critical unfixed Apple bug
        for subview in themeSelectionMenu.view.subviews {
            for constraint in subview.constraints where constraint.debugDescription.contains("width == - 16") {
                subview.removeConstraint(constraint)
            }
        }
        
        sampleAppVC.present(themeSelectionMenu, animated: true, completion: nil)
    }
    
    func showAuditTrailImages() {
        var auditTrailAndIDScanImages: [UIImage] = []
        let latestFaceTecSessionResult = sampleAppVC.latestSessionResult
        let latestFaceTecIDScanResult = sampleAppVC.latestIDScanResult
        
        // Update audit trail.
        if latestFaceTecSessionResult?.auditTrailCompressedBase64 != nil {
            for compressedBase64EncodedAuditTrailImage in (latestFaceTecSessionResult?.auditTrailCompressedBase64)! {
                let dataDecoded : Data = Data(base64Encoded: compressedBase64EncodedAuditTrailImage, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                auditTrailAndIDScanImages.append(decodedimage!)
            }
        }
        
        if latestFaceTecIDScanResult != nil
            && latestFaceTecIDScanResult?.frontImagesCompressedBase64 != nil
            && (latestFaceTecIDScanResult?.frontImagesCompressedBase64?.count)! > 0 {
            let dataDecoded : Data = Data(base64Encoded: (latestFaceTecIDScanResult?.frontImagesCompressedBase64?[0])!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            auditTrailAndIDScanImages.append(decodedimage!)
        }
        
        if latestFaceTecIDScanResult != nil
            && latestFaceTecIDScanResult?.backImagesCompressedBase64 != nil
            && (latestFaceTecIDScanResult?.backImagesCompressedBase64?.count)! > 0 {
            let dataDecoded : Data = Data(base64Encoded: (latestFaceTecIDScanResult?.backImagesCompressedBase64?[0])!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            auditTrailAndIDScanImages.append(decodedimage!)
        }
      
        for auditImage in auditTrailAndIDScanImages.reversed() {
            addDismissableImageToInterface(image: auditImage)
        }
    }
    
    @objc func dismissImageView(tap: UITapGestureRecognizer){
        let tappedImage = tap.view!
        tappedImage.removeFromSuperview()
    }
    
    // Place a UIImage onto the main interface in a stack that can be popped by tapping on the image
    func addDismissableImageToInterface(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = UIScreen.main.bounds
        
        // Resize image to better fit device's display
        // Remove this option to view image full screen
        let screenSize = UIScreen.main.bounds
        let ratio = screenSize.width / image.size.width
        let size = (image.size).applying(CGAffineTransform(scaleX: 0.5 * ratio, y: 0.5 * ratio))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = scaledImage
        imageView.contentMode = .center
        
        // Tap on image to dismiss view
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissImageView(tap:)))
        imageView.addGestureRecognizer(tap)
        
        sampleAppVC.view.addSubview(imageView)
    }
    
    func handleThemeSelection(theme: String) {
        currentTheme = theme
        ThemeHelpers.setAppTheme(theme: theme)
        updateThemeTransitionView()

        // Set this class as the delegate to handle the FaceTecCustomAnimationDelegate methods. This delegate needs to be applied to the current FaceTecCustomization object before starting a new Session in order to use FaceTecCustomAnimationDelegate methods to provide a new instance of a custom UIView that will be displayed for the method-specified animation.
        if(Config.currentCustomization.customAnimationDelegate == nil) {
            Config.currentCustomization.customAnimationDelegate = self
            SampleAppUtilities.setVocalGuidanceSoundFiles()
            FaceTec.sdk.setCustomization(Config.currentCustomization)
        }
    }
    
    func updateThemeTransitionView() {
        var transitionViewImage: UIImage? = nil
        var transitionTextColor = Config.currentCustomization.guidanceCustomization.foregroundColor
        switch currentTheme {
            case "FaceTec Theme":
                break
            case "Config Wizard Theme":
                break
            case "Pseudo-Fullscreen":
                break
            case "Well-Rounded":
                transitionViewImage = UIImage(named: "well_rounded_bg")
                transitionTextColor = Config.currentCustomization.frameCustomization.backgroundColor
                break
            case "Bitcoin Exchange":
                transitionViewImage = UIImage(named: "bitcoin_exchange_bg")
                transitionTextColor = Config.currentCustomization.frameCustomization.backgroundColor
                break
            case "eKYC":
                transitionViewImage = UIImage(named: "ekyc_bg")
                break
            case "Sample Bank":
                transitionViewImage = UIImage(named: "sample_bank_bg")
                transitionTextColor = Config.currentCustomization.frameCustomization.backgroundColor
                break
            default:
                break
        }
        
//        self.sampleAppVC.themeTransitionImageView.image = transitionViewImage != nil ? transitionViewImage : UIImage()
//        self.sampleAppVC.themeTransitionText.textColor = transitionTextColor
    }
    
    func onCreateNewResultScreenActivityIndicatorView() -> UIView? {
        var activityIndicatorView: UIView? = nil
        switch currentTheme {
            case "FaceTec Theme":
                break
            case "Config Wizard Theme":
                break
            case "Pseudo-Fullscreen":
                activityIndicatorView = PseudoFullscreenActivityIndicatorView()
                break
            case "Well-Rounded":
                activityIndicatorView = WellRoundedActivityIndicatorView()
                break
            case "Bitcoin Exchange":
                break
                break
            case "Sample Bank":
                break
            default:
                break
        }
        return activityIndicatorView
    }
    
    func onCreateNewResultScreenSuccessAnimationView() -> UIView? {
        var successAnimationView: UIView? = nil
        switch currentTheme {
            case "FaceTec Theme":
                successAnimationView = WellRoundedSuccessView()
                break
            case "Config Wizard Theme":
                break
            case "Pseudo-Fullscreen":
                successAnimationView = PseudoFullscreenSuccessView()
                break
            case "Well-Rounded":
                successAnimationView = WellRoundedSuccessView()
                break
            case "Bitcoin Exchange":
                break
            case "Sample Bank":
                break
            default:
                break
        }
        return successAnimationView
    }
    
    func onCreateNewResultScreenUnsuccessAnimationView() -> UIView? {
        var unsuccessAnimationView: UIView? = nil
        switch currentTheme {
            case "FaceTec Theme":
                break
            case "Config Wizard Theme":
                break
            case "Pseudo-Fullscreen":
                unsuccessAnimationView = PseudoFullscreenUnsuccessView()
                break
            case "Well-Rounded":
                unsuccessAnimationView = WellRoundedUnsuccessView()
                break
            case "Bitcoin Exchange":
                break
            case "Sample Bank":
                break
            default:
                break
        }
        return unsuccessAnimationView
    }
    
    func onCreateAdditionalReviewScreenAnimationView() -> UIView? {
        var animationView: UIView? = nil
        switch currentTheme {
            case "FaceTec Theme":
                animationView = AdditionalReviewAnimationView()
                break
            case "Config Wizard Theme":
                break
            case "Pseudo-Fullscreen":
                break
            case "Well-Rounded":
                break
            case "Bitcoin Exchange":
                animationView = AdditionalReviewAnimationViewOrange()
                break
            case "Sample Bank":
                break
            default:
                break
        }
        return animationView
    }
    
    func onCreateInitialLoadingAnimationView() -> UIView? {
        var animationView: UIView? = nil
        switch currentTheme {
            case "FaceTec Theme":
                break
            case "Config Wizard Theme":
                break
            case "Pseudo-Fullscreen":
                animationView = PseudoFullscreenActivityIndicatorView()
                break
            case "Well-Rounded":
                animationView = WellRoundedActivityIndicatorView()
                break
            case "Bitcoin Exchange":
                break
            case "Sample Bank":
                break
            default:
                break
        }
        return animationView
    }
    
    func onCreateOCRConfirmationScrollIndicatorAnimationView() -> UIView? {
        var animationView: UIView? = nil
        switch currentTheme {
            case "FaceTec Theme":
                break
            case "Config Wizard Theme":
                break
            case "Pseudo-Fullscreen":
                break
            case "Well-Rounded":
                break
            case "Bitcoin Exchange":
                break
            case "Sample Bank":
                break
            default:
                break
        }
        return animationView
    }
    
    func setUpVocalGuidancePlayers() {
        SampleAppUtilities.sampleAppVocalGuidanceMode = .MINIMAL

        guard let vocalGuidanceOnUrl = Bundle.main.url(forResource: "vocal_guidance_on", withExtension: "mp3") else { return }
        guard let vocalGuidanceOffUrl = Bundle.main.url(forResource: "vocal_guidance_off", withExtension: "mp3") else { return }

        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            vocalGuidanceOnPlayer = try AVAudioPlayer(contentsOf: vocalGuidanceOnUrl)
            vocalGuidanceOffPlayer = try AVAudioPlayer(contentsOf: vocalGuidanceOffUrl)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setVocalGuidanceMode() {
        if !(AVAudioSession.sharedInstance().outputVolume > 0) {
            let alert = UIAlertController(title: nil, message: "Vocal Guidance is disabled when the device is muted", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.sampleAppVC.present(alert, animated: true, completion: nil)
            return
        }
        
        if vocalGuidanceOnPlayer.isPlaying || vocalGuidanceOffPlayer.isPlaying {
            return
        }

        DispatchQueue.main.async {
            switch(SampleAppUtilities.sampleAppVocalGuidanceMode) {
            case .OFF:
                SampleAppUtilities.sampleAppVocalGuidanceMode = .MINIMAL
//                self.sampleAppVC.vocalGuidanceSettingButton.setImage(UIImage(named: "vocal_minimal.png"), for: .normal)
                self.vocalGuidanceOnPlayer.play()
                Config.currentCustomization.vocalGuidanceCustomization.mode = FaceTecVocalGuidanceMode.minimalVocalGuidance
            case .MINIMAL:
                SampleAppUtilities.sampleAppVocalGuidanceMode = .FULL;
//                self.sampleAppVC.vocalGuidanceSettingButton.setImage(UIImage(named: "vocal_full.png"), for: .normal)
                self.vocalGuidanceOnPlayer.play()
                Config.currentCustomization.vocalGuidanceCustomization.mode = FaceTecVocalGuidanceMode.fullVocalGuidance
            case .FULL:
                SampleAppUtilities.sampleAppVocalGuidanceMode = .OFF;
//                self.sampleAppVC.vocalGuidanceSettingButton.setImage(UIImage(named: "vocal_off.png"), for: .normal)
                self.vocalGuidanceOffPlayer.play()
                Config.currentCustomization.vocalGuidanceCustomization.mode = FaceTecVocalGuidanceMode.noVocalGuidance
            default: break
            }
            SampleAppUtilities.setVocalGuidanceSoundFiles()
            FaceTec.sdk.setCustomization(Config.currentCustomization)
        }
    }
    
    public static func setVocalGuidanceSoundFiles() {
        Config.currentCustomization.vocalGuidanceCustomization.pleaseFrameYourFaceInTheOvalSoundFile = Bundle.main.path(forResource: "please_frame_your_face_sound_file", ofType: "mp3") ?? ""
        Config.currentCustomization.vocalGuidanceCustomization.pleaseMoveCloserSoundFile = Bundle.main.path(forResource: "please_move_closer_sound_file", ofType: "mp3") ?? ""
        Config.currentCustomization.vocalGuidanceCustomization.pleaseRetrySoundFile = Bundle.main.path(forResource: "please_retry_sound_file", ofType: "mp3") ?? ""
        Config.currentCustomization.vocalGuidanceCustomization.uploadingSoundFile = Bundle.main.path(forResource: "uploading_sound_file", ofType: "mp3") ?? ""
        Config.currentCustomization.vocalGuidanceCustomization.facescanSuccessfulSoundFile = Bundle.main.path(forResource: "facescan_successful_sound_file", ofType: "mp3") ?? ""
        Config.currentCustomization.vocalGuidanceCustomization.pleasePressTheButtonToStartSoundFile = Bundle.main.path(forResource: "please_press_button_sound_file", ofType: "mp3") ?? ""
        
        switch(SampleAppUtilities.sampleAppVocalGuidanceMode) {
        case .OFF:
            Config.currentCustomization.vocalGuidanceCustomization.mode = FaceTecVocalGuidanceMode.noVocalGuidance
        case .MINIMAL:
            Config.currentCustomization.vocalGuidanceCustomization.mode = FaceTecVocalGuidanceMode.minimalVocalGuidance
        case .FULL:
            Config.currentCustomization.vocalGuidanceCustomization.mode = FaceTecVocalGuidanceMode.fullVocalGuidance
        default: break
        }
    }
    
    public static func setOCRLocalization() {
        // Set the strings to be used for group names, field names, and placeholder texts for the FaceTec ID Scan User OCR Confirmation Screen.
        // DEVELOPER NOTE: For this demo, we are using the template json file, 'FaceTec_OCR_Customization.json,' as the parameter in calling this API.
        // For the configureOCRLocalization API parameter, you may use any dictionary object that follows the same structure and key naming as the template json file, 'FaceTec_OCR_Customization.json'.
        if let path = Bundle.main.path(forResource: "FaceTec_OCR_Customization", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                if let jsonDictionary = jsonObject as? Dictionary<String, AnyObject> {
                    FaceTec.sdk.configureOCRLocalization(dictionary: jsonDictionary)
                }
            } catch {
                print("Error loading JSON for OCR Localization")
            }
        }
    }
}
