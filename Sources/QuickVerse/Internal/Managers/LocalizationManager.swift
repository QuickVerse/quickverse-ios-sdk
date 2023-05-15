import Foundation

class LocalizationManager {
    private let apiClient: API
    init(apiClient: API) {
        self.apiClient = apiClient
    }
}

extension LocalizationManager {
    func getLocalizationsFor(languageCode: String, completion: @escaping (Result<QuickVerseResponse, APIError>) -> Void) {
        guard let url = URL(string: RequestBuilder.buildLocalizationRequest(languageCode: languageCode)) else {
            return completion(.failure(.invalidURL))
        }
        let request = Request(url: url, httpMethod: .get, body: nil)
        apiClient.makeRequest(request: request) { (result: Result<QuickVerseResponse, APIError>) in
            completion(result)
        }
    }
}
