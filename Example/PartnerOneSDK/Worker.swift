import UIKit
import Alamofire
import ObjectMapper

protocol PartnerOneWorkerProtocol: AnyObject {
  func parseMainData(_ completion: @escaping (_ response: Response<TestModel>) -> Void)
  func postCPF(cpf: String, completion: @escaping (Response<AuthenticationModel>) -> Void)
}

class PartnerOneWorker: Request, PartnerOneWorkerProtocol {
  
  let network = DataParser()
  let apiURL = "https://integracao-sodexo-homologacao.partner1.com.br/swagger/v1/swagger.json/"
  
  func parseMainData(_ completion: @escaping (Response<TestModel>) -> Void) {
    guard let url = URL(string: "\(apiURL)") else {
      return
    }
    
    let params: Parameters = [
      "username": "HMG.IOS",
      "password": "eQtlC7BM",
      "grant_type": "password"
    ]
    
    network.mapperParser(url: url, method: .get, parameters: params, completion: completion)
  }
  
  func postCPF(cpf: String, completion: @escaping (Response<AuthenticationModel>) -> Void) {
    guard let url = URL(string: "\(apiURL)/api/authentication") else {
      return
    }
    
    let params: Parameters = [
      "cpf": cpf
    ]
    
    network.mapperParser(url: url, method: .post, parameters: params, completion: completion)
  }
  
  func testCall() {
    let endpoint = apiURL
    let request = NSMutableURLRequest(url: NSURL(string: endpoint)! as URL)
    
    request.httpMethod = "POST"
    request.addValue("username", forHTTPHeaderField: "HMG.IOS")
    request.addValue("password", forHTTPHeaderField: "eQtlC7BM")
    request.addValue("grant_type", forHTTPHeaderField: "password")

    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
        guard let data = data else {
            print("Exception raised while attempting HTTPS call.")
            return
        }
        if let responseJSONObj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] {
          print("@! >>> RESPONSE: ", responseJSONObj)
            if((responseJSONObj["paths"] as? String) != nil) {
//                self.utils?.hideSessionTokenConnectionText()
//                sessionTokenCallback(responseJSONObj["sessionToken"] as! String)
              print(responseJSONObj["paths"] as! String)
                return
            } else {
                print("Exception raised while attempting HTTPS call.")
            }
        }
    })
    task.resume()
  }
}
