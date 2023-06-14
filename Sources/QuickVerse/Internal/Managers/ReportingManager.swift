import Foundation

class ReportingManager {
    private let apiClient: API
    init(apiClient: API) {
        self.apiClient = apiClient
    }
    
    struct UtilisedKey {
        let key: String
        var count: Int
    }
    struct MissingKey {
        let key: String
        let defaultValue: String
    }
    
    private let keyLimit = 4
    private var missingKeys: [MissingKey] = []
    private var utilisedKeys: [UtilisedKey] = []
    private var needsTransmission: Bool {
        if !missingKeys.isEmpty {
            return true
        } else {
            let utilisedCount = utilisedKeys.compactMap { $0.count }.reduce(0, +)
            return (missingKeys.count + utilisedCount) >= keyLimit
        }
    }
    private var requestInFlight: Bool = false
}

extension ReportingManager {
    func logUtilisedKey(_ key: String) {
        let existingCount = utilisedKeys.first(where: { $0.key == key })?.count ?? 0
        let newCount = existingCount + 1
        utilisedKeys.removeAll(where: { $0.key == key })
        utilisedKeys.append(UtilisedKey(key: key, count: newCount))
        uploadKeyDataIfNecessary()
    }
    func logMissingKey(_ key: String, defaultValue: String?) {
        missingKeys.removeAll(where: { $0.key == key })
        missingKeys.append(MissingKey(key: key, defaultValue: defaultValue ?? ""))
        uploadKeyDataIfNecessary()
    }
}

extension ReportingManager {
    func uploadKeyDataIfNecessary() {
        guard
            needsTransmission,
            !requestInFlight else { return }
        
        var missing: [[String: Any]] = [[:]]
        missingKeys.forEach { missingKey in
            missing.append(["key": missingKey.key, "default_value": missingKey.defaultValue])
        }
        var utilised: [[String: Any]] = [[:]]
        utilisedKeys.forEach { utilisedKey in
            utilised.append(["key": utilisedKey.key, "usage_count": utilisedKey.count])
        }
        let json: [String: Any] = ["missing_keys": missing, "utilised_keys": utilised]
        
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: json),
            let url = URL(string: RequestBuilder.buildAnalyticsRequest()) else { return }

        requestInFlight = true
        
        let request = Request(url: url, httpMethod: .post, body: jsonData)
        apiClient.makeRequest(request: request) { [weak self] (result: Result<Void, APIError>) in
            guard let self else { return }
            switch result {
            case .success:
                self.missingKeys.removeAll()
                self.utilisedKeys.removeAll()
            case .failure:
                // Request failed, do not clear keys, retry on next
                break
            }
            self.requestInFlight = false
        }
    }
}
