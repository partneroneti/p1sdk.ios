import Foundation
import ObjectMapper

struct DocumentDataModel: Mappable {
  var type: String?
  var byte: String?
  
  init?(map: Map) {
    type = (try? map.value("type")) ?? ""
    byte = (try? map.value("byte")) ?? ""
  }

  mutating func mapping(map: Map) {
    type <- map["type"]
    byte <- map["byte"]
  }
}
