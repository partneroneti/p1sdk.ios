import UIKit
import Alamofire
import ObjectMapper

protocol PartnerOneWorkerProtocol: AnyObject {
  func sendPictures(transactionId: String,
                    type: String,
                    byte: String,
                    completion: @escaping (_ response: Response<DocumentModel>) -> Void)
}

class PartnerOneWorker: Request, PartnerOneWorkerProtocol {
  
  let network = DataParser()
  var apiURL = "https://integracao-sodexo-homologacao.partner1.com.br/api"
  
  init(apiURL: String) {
    self.apiURL = apiURL
  }
  
  func sendPictures(transactionId: String,
                    type: String,
                    byte: String,
                    completion: @escaping (Response<DocumentModel>) -> Void) {
    guard let url = URL(string: "\(apiURL)/document") else {
      return
    }
    
    let bodyData: [String:Any] = [
      "transactionId": "HMG.IOS",
      "documents": [
        "type": "\(type)",
        "byte": "\(byte)"
      ]
    ]
    
    network.mainParser(url: url, body: bodyData, method: .post, completion: completion)
  }
}
