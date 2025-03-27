import AcessoBio

final class AppThemes: AcessoBioThemeDelegate {
    func getColorBackground() -> Any! { UIColor(hexString: "#727175") }
    
    func getColorBoxMessage() -> Any! { UIColor(hexString: "#00EC55") }
    
    func getColorTextMessage() -> Any! { UIColor(hexString: "#1F193D") }
    
    func getColorBackgroundPopupError() -> Any! { UIColor(hexString: "#1F193D") }
    
    func getColorTextPopupError() -> Any! { UIColor(hexString: "#ffffff") }
    
    func getColorBackgroundButtonPopupError() -> Any! { UIColor(hexString: "#00EC55") }
    
    func getColorTextButtonPopupError() -> Any! { UIColor(hexString: "#727175") }
    
    func getColorBackgroundTakePictureButton() -> Any! { UIColor(hexString: "#00EC55") }
    
    func getColorIconTakePictureButton() -> Any! { UIColor(hexString: "#1F193D") }
    
    func getColorBackgroundBottomDocument() -> Any! { UIColor(hexString: "#727175") }
    
    func getColorTextBottomDocument() -> Any! { UIColor(hexString: "#00EC55") }
    
    func getColorSilhouetteSuccess() -> Any! { UIColor(hexString: "#ffffff") }
    
    func getColorSilhouetteError() -> Any! { UIColor(hexString: "#ffffff") }
    
    func getColorSilhouetteNeutral() -> Any! { UIColor(hexString: "#ffffff") }
}
