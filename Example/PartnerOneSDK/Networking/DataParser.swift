import UIKit
import Foundation
import Alamofire
import ObjectMapper
import PartnerOneSDK
// import FaceTecSDK (Removido na v2.22.0)

class DataParser: NSObject, URLSessionTaskDelegate {
  
    //var faceScanResultCallback: Any? // FaceTecFaceScanResultCallback! (Removido na v2.22.0)
  
    func mainParser<T: Mappable>(url: URL,
                               body: [String:Any],
                               method: HTTPMethod,
                               completion: @escaping ((Response<T>) -> Void)) {
    
        let jsonData = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "\(method)"
        request.httpBody = jsonData
    
      Alamofire.request(request).response { (response) in
        guard let statusCode = response.response?.statusCode,
              let data = response.data else {
          return
        }
        
        print("@! >>> Status code da requisição de \(url): ", statusCode)
        
        if statusCode == 200 {
          let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
          
          guard let item = responseJSON as? [String:Any] else {
            return
          }
          
          let model = Mapper<T>().map(JSON: item)
          completion(.success(model: model!))
        } else {
          print("Não conseguimos receber os dados da API...")
        }
      }
  }
  
  func loginParser<T: Mappable>(url: URL,
                                body: [String:Any] = [:],
                                header: String,
                                method: HTTPMethod,
                                completion: @escaping ((Response<T>) -> Void)) {
    
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])

        var request = URLRequest(url: url)
        request.addValue("Bearer \(header)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        request.addValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "\(method)"
        request.httpBody = jsonData
    
      Alamofire.request(request).response { (response) in
        guard let statusCode = response.response?.statusCode,
              let data = response.data else {
          return
        }
        
        print("@! >>> Status code da requisição de \(url): ", statusCode)
        
        if statusCode == 200 {
          let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
          
          guard let item = responseJSON as? [String:Any] else {
            return
          }
          
          let model = Mapper<T>().map(JSON: item)
          completion(.success(model: model!))
        } else {
          print("Não conseguimos receber os dados da API...")
        }
      }
  }
  
  func getParser<T: Mappable>(url: URL,
                              header: String = "",
                              method: HTTPMethod,
                              isSession: Bool = false,
                              userAgent: String = "",
                              xDeviceKey: String = "",
                              completion: @escaping ((Response<T>) -> Void)) {
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(header)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("text/plain", forHTTPHeaderField: "Accept")
    request.addValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
    if isSession {
      request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
      request.addValue(xDeviceKey, forHTTPHeaderField: "X-Device-Key")
    }
    
      print("url >> \(url)")
      print("HEADERS >>> \(request.allHTTPHeaderFields)")
      
    request.httpMethod = "\(method)"
      
      Alamofire.request(request).response { (response) in
        guard let statusCode = response.response?.statusCode,
              let data = response.data else {
          return
        }
        
        print("@! >>> Status code da requisição de \(url): ", statusCode)
        
        if statusCode == 200 {
          let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
          
          guard let item = responseJSON as? [String:Any] else {
            return
          }
            
            print("RESPONSe \(item)")
          
          let model = Mapper<T>().map(JSON: item)
          completion(.success(model: model!))
        } else {
          print("Não conseguimos receber os dados da API...")
        }
      }
    
//    task.resume()
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
      // let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
      // faceScanResultCallback.onFaceScanUploadProgress(uploadedPercent: uploadProgress) (Gerenciado internamente na v2.22.0)
  }
}

