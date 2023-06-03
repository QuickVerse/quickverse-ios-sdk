import Foundation

class LocalizationManager {
    var successfulFetch: Bool = false
    private let apiClient: API
    init(apiClient: API) {
        self.apiClient = apiClient
    }
}

extension LocalizationManager {
    func getLocalizationsFor(languageCode: String, completion: @escaping (Result<QuickVerseResponse, APIError>) -> Void) {
        var languageCodesWithFallbacks = Locale.preferredLanguages
        languageCodesWithFallbacks.removeAll(where: { $0 == languageCode })
        languageCodesWithFallbacks.insert(languageCode, at: 0)
        guard let url = URL(string: RequestBuilder.buildLocalizationRequest(languageCodes: languageCodesWithFallbacks)) else {
            return completion(.failure(.invalidURL))
        }
        let request = Request(url: url, httpMethod: .get, body: nil)
        apiClient.makeRequest(request: request) { [weak self] (result: Result<QuickVerseResponse, APIError>) in
            guard let self else { return completion(.failure(.generic(500))) }
            if case .success = result { successfulFetch = true }
            completion(result)
        }
    }
}
