import Foundation

class SecretsManager {
    static let shared = SecretsManager()
    
    private var secrets: [String: Any]?

    private init() {
        let bundles = [Bundle.main, Bundle(for: SecretsManager.self)]
        for bundle in bundles {
            if let path = bundle.path(forResource: "Secrets", ofType: "plist"),
               let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                self.secrets = dict
                break
            }
        }
    }

    func getSecret(forKey key: String) -> String {
        return secrets?[key] as? String ?? ""
    }
    
    var apiUrl: String { getSecret(forKey: "API_URL") }
    var webhookUrl: String { getSecret(forKey: "WEBHOOK_URL") }
    var hmgUser: String { getSecret(forKey: "HMG_USER") }
    var hmgPassword: String { getSecret(forKey: "HMG_PASSWORD") }
}
