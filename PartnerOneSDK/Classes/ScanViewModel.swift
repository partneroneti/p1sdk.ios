import UIKit

enum PictureView {
  case frontView
  case backView
}

open class ScanViewModel {
  
  var helper: PartnerHelper?
  var sideTitle: String = ""
  var transactionID: String = ""
  var documents = [AnyObject]()
  
  init(helper: PartnerHelper?) {
    self.helper = helper
  }
  
  func setPhotoSide(_ cases: PictureView) -> String {
    switch cases {
    case .backView:  return "Verso"
    case .frontView: return "Frente"
    }
  }
  
  func navigateToNextView(_ viewController: UIViewController) {
    if sideTitle == setPhotoSide(.frontView) {
      let nextViewController = ScanViewController(viewModel: self, viewTitle: "Verso")
      viewController.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
//    if sideTitle == setPhotoSide(.backView) {
//      let nextViewController = FacialScanViewController(viewModel: self)
//      viewController.navigationController?.pushViewController(nextViewController, animated: true)
//    }
  }
  
  func navigateToPreviewView(_ viewController: UIViewController) {
    if sideTitle == setPhotoSide(.backView) {
      viewController.navigationController?.popViewController(animated: true)
    }
  }
  
  func sendPicture() {
    helper?.sendDocumentPicture?()
    print("@! >>> Enviando imagens dos documentos...")
  }
}
