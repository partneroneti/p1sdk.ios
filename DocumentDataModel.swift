import Foundation
import ObjectMapper

public struct DocumentDataModel: Mappable {
  var type: String?
  var byte: String?
  
  public init?(map: Map) {
    type = (try? map.value("type")) ?? ""
    byte = (try? map.value("byte")) ?? ""
  }

  mutating public func mapping(map: Map) {
    type <- map["type"]
    byte <- map["byte"]
  }
}
