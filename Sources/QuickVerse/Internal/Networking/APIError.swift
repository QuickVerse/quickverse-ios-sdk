enum APIError: Error {
    case noAPIKey
    case noBundleID
    case invalidToken
    case invalidURL
    case noResponse
    case noData
    case unauthorized // 401
    case generic(Int) // Returns error code for inspection
    case decoding
}
