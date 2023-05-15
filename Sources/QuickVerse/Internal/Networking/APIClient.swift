import Foundation
import UIKit

protocol API {
    func makeRequest<T: Decodable>(request: Request, completion: @escaping (Result<T, APIError>) -> Void)
    func makeRequest(request: Request, completion: @escaping (Result<Void, APIError>) -> Void)
}

class APIClient: API {
    var apiKey: String!
    private let sdkVersion = "1.4.1"
    
    private let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
}

extension APIClient {
    func makeRequest<T: Decodable>(request: Request, completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let apiKey, !apiKey.isEmpty else { return completion (.failure(.noAPIKey)) }
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return completion (.failure(.noBundleID)) }
        
        let tokenString = "\(bundleIdentifier):\(apiKey)"
        guard let tokenData = tokenString.data(using: .utf8) else { return completion (.failure(.invalidToken)) }
        let tokenEncoded = tokenData.base64EncodedString()
        
        let urlRequest = buildURLRequestWith(request: request, token: tokenEncoded)
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return completion(.failure(.noResponse)) }
            guard let data else { return completion(.failure(.noData)) }
            
            guard (200...300).contains(response.statusCode) else {
                switch response.statusCode {
                case 401: return completion(.failure(.unauthorized))
                default: return completion(.failure(.generic(response.statusCode)))
                }
            }
            do {
                let decoder = JSONDecoder()
                try completion(.success(decoder.decode(T.self, from: data)))
            } catch {
                completion(.failure(.decoding))
            }
            
        }.resume()
    }
    func makeRequest(request: Request, completion: @escaping (Result<Void, APIError>) -> Void) {
        
        guard let apiKey, !apiKey.isEmpty else { return completion (.failure(.noAPIKey)) }
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return completion (.failure(.noBundleID)) }
        
        let tokenString = "\(bundleIdentifier):\(apiKey)"
        guard let tokenData = tokenString.data(using: .utf8) else { return completion (.failure(.invalidToken)) }
        let tokenEncoded = tokenData.base64EncodedString()
        
        let urlRequest = buildURLRequestWith(request: request, token: tokenEncoded)
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return completion(.failure(.noResponse)) }
   
            guard (200...300).contains(response.statusCode) else {
                switch response.statusCode {
                case 401: return completion(.failure(.unauthorized))
                default: return completion(.failure(.generic(response.statusCode)))
                }
            }
            completion(.success(()))
        }.resume()
    }
}

extension APIClient {
    private func buildURLRequestWith(request: Request, token: String) -> URLRequest {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("Apple", forHTTPHeaderField: "Platform")
        urlRequest.setValue(sdkVersion, forHTTPHeaderField: "X_QUICKVERSE_VERSION")
        
        // NOTE: This is *not* an advertising identifier. It has no implication for privacy declarations.
        let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
        urlRequest.setValue(vendorIdentifier, forHTTPHeaderField: "X-QUICKVERSE-DEVICEID")
        
        return urlRequest
    }
}
