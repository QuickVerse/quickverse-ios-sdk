import Foundation

public class QuickVerse {
    private init() {}
    public static let shared = QuickVerse()
    
    private var apiKey: String!
    public var isDebugEnabled: Bool = false

    private var localizations = [QuickVerseLocalization]()
    private let sdkVersion = "1.3.0"
}

// MARK: - Public Methods

extension QuickVerse {
    /// Configures the SDK with the API key from your quickverse.io account. Must be called before you can use the SDK. We strongly recommend you call this on app initialisation, e.g. AppDelegate.
    public func configure(apiKey: String) {
        guard !apiKey.isEmpty else {
            fatalError("🚨 API Key not provided. Please call this method with your API key from https://quickverse.io.")
        }
        self.apiKey = apiKey
    }
}

/**
 Use these methods to fetch the localizations you have created on quickverse.io.
 You will typically want to call this on launch, before you display any copy.
 */
extension QuickVerse {
    /// Fetches your quickverse localizations for the user's device language setting. Unless you have a very specific use case, this is the method you'll want you use.
    public func getLocalizations(completion: @escaping (_ success: Bool) ->()) {
        let languageCode = retrieveDeviceLanguageCode()
        getLocalizationsFor(languageCode: languageCode, completion: completion)
    }
    /// Fetches your quickverse localizations for a specific language code you provide. This must be a two-letter ISO 639-1 code: https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
    public func getSpecificLocalizations(languageCode: String, completion: @escaping (_ success: Bool) ->()) {
        getLocalizationsFor(languageCode: languageCode, completion: completion)
    }
}

/**
Use these methods to retrieve values for the localizations you fetched using one of the "get" methods above.
You can call these from anywhere in your app, e.g. Quickverse.stringFor(key: "Onboarding.Welcome.Title")
*/
extension QuickVerse {
    /// Returns the value for a specific key, falling back to a default value
    public func stringFor(key: String, defaultValue: String) -> String {
        let value = stringFor(key: key)
        if value == nil {
            logStringKeyNotFound(key)
        }
        return value ?? defaultValue
    }
    /// Returns the value for a specific key, or null if one does not exist
    public func stringFor(key: String) -> String? {
        return localizations.first(where: { $0.key == key })?.value
    }
}

// MARK: - Internal Methods
extension QuickVerse {
    private func getLocalizationsFor(languageCode: String, completion: @escaping (_ success: Bool) ->()) {
        guard let apiKey else {
            fatalError("🚨 API Key not configured. Please configure the SDK on your app startup (usually AppDelegate) with your API key from https://quickverse.io.")
        }
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("🚨 No bundle ID found. QuickVerse requires a valid Bundle ID to authenticate requests. If this is unexpected, please contact team@quickverse.io.")
        }
        let tokenString = "\(bundleIdentifier):\(apiKey)"
        guard let tokenData = tokenString.data(using: .utf8) else {
            fatalError("🚨 Unable to generate auth token. Please contact team@quickverse.io.")
        }
        let tokenEncoded = tokenData.base64EncodedString()
        
        if QuickVerse.shared.isDebugEnabled {
            QuickVerseLogger.logStatement("ℹ️ Retrieving localizations for language code: \(languageCode)")
        }
        
        guard let url = URL(string: "https://quickverse.io/sdk/api/localisation/\(languageCode)") else {
            fatalError("🚨 Unable to create request url. Please contact team@quickverse.io.")
        }
        
        let request = buildURLRequestWith(url: url, token: tokenEncoded)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard
                let response = response as? HTTPURLResponse,
                let data = data else {
                QuickVerseLogger.logStatement("🚨 WARN: No response received. Have you added at least one localization in your quickverse.io account?")
                return completion(false)
            }
            
            guard response.statusCode == 200 else {
                switch response.statusCode {
                case 401:
                    QuickVerseLogger.logStatement("🚨 WARN: API Key incorrect, or application has been been added to your quickverse.io account.")
                default: break
                }
                return completion(false)
            }
            
            guard let localizationResponse = try? JSONDecoder().decode(QuickVerseResponse.self, from: data) else {
                QuickVerseLogger.logStatement("🚨 WARN: Localizations parse failed. Please contact support at team@quickverse.io.")
                return completion(false)
            }
            
            let localizations = localizationResponse.data.localisations
            if localizations.isEmpty {
                QuickVerseLogger.logStatement("🚨 WARN: Localizations empty. Please add at least one localization entry to your account on quickverse.io.")
            }
            if QuickVerse.shared.isDebugEnabled {
                QuickVerseLogger.printCodeForAvailableLocalizations(localizations)
            }
            
            QuickVerse.shared.localizations = localizations
            return completion(true)
        }).resume()
    }
}

extension QuickVerse {
    // You shouldn't need to access this, but we've left it open for specific use cases
    public func retrieveDeviceLanguageCode() -> String {
        var languageCode = Locale.preferredLanguages.first
        if languageCode == nil {
            if #available(iOS 16, macOS 13, *) {
                languageCode = Locale.current.language.languageCode?.identifier
            } else {
                languageCode = Locale.current.languageCode
            }
        }
        return languageCode ?? "en"
    }
    
    private func buildURLRequestWith(url: URL, token: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("Apple", forHTTPHeaderField: "Platform")
        request.setValue(sdkVersion, forHTTPHeaderField: "X_QUICKVERSE_VERSION")
        return request
    }
}

extension QuickVerse {
    private func logStringKeyNotFound(_ key: String) {
        if localizations.isEmpty {
            QuickVerseLogger.logStatement("🚨 WARN: No localizations have been received. Have you added at least one localization to your quickverse account? If yes, did your fetchLocaliZations request succeed?")
        } else {
            QuickVerseLogger.logStatement("🚨 WARN: Value not found for referenced key: \(key). Please check this key exists in your quickverse.io account.")
        }
    }
}
