import Foundation
import ObjectMapper

struct LivenessModel: Mappable {
  var code: Int?
  var description: String?
  
  init?(map: Map) {
    code = (try? map.value("timeProcess")) ?? 0
    description = (try? map.value("description")) ?? ""
  }
  
  mutating func mapping(map: Map) {
    code <- map["code"]
    description <- map["description"]
  }
}
