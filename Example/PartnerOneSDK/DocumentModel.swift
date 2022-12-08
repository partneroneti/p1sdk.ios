import Foundation
import ObjectMapper

struct DocumentModel: Mappable {
  var transactionId: String?
  var documents: [DocumentDataModel]
  
  init?(map: Map) {
    transactionId = (try? map.value("transactionId")) ?? ""
    documents = [(try? map.value("documents")) ?? DocumentDataModel(map: map)!]
  }

  mutating func mapping(map: Map) {
    transactionId <- map["transactionId"]
    documents <- map["documents"]
  }
}
