import Foundation

/// Convenience global accessor, allowing you to call QuickVerse methods with shorter footprint, for example: QuickVerse.getLocalizations(
public let QuickVerse = QuickVerseManager.shared

public class QuickVerseManager {
    public static let shared = QuickVerseManager()
    
    private let apiClient: APIClient
    private let localizationManager: LocalizationManager
    private let reportingManager: ReportingManager
    private init() {
        apiClient = APIClient(session: URLSession.shared)
        localizationManager = LocalizationManager(apiClient: apiClient)
        reportingManager = ReportingManager(apiClient: apiClient)
    }
    
    public var isDebugEnabled: Bool = false
    private var localizations = [QuickVerseLocalization]()
}

// MARK: - Public Methods

extension QuickVerseManager {
    /// Configures the SDK with the API key from your quickverse.io account. Must be called before you can use the SDK. We strongly recommend you call this on app initialisation, e.g. AppDelegate.
    public func configure(apiKey: String) {
        guard !apiKey.isEmpty else {
            fatalError("🚨 API Key not provided. Please call this method with your API key from https://quickverse.io.")
        }
        apiClient.apiKey = apiKey
    }
}

/**
 Use these methods to fetch the localizations you have created on quickverse.io.
 You will typically want to call this on launch, before you display any copy.
 */
extension QuickVerseManager {
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
extension QuickVerseManager {
    /// Returns the value for a specific key, falling back to a default value
    public func stringFor(key: String, defaultValue: String) -> String {
        let value = stringFor(key: key)
        return value ?? defaultValue
    }
    /// Returns the value for a specific key, or null if one does not exist
    public func stringFor(key: String) -> String? {
        let value = localizations.first(where: { $0.key == key })?.value
        logRequestedKey(key, defaultValue: "", wasPresent: value != nil)
        return value
    }
}

// MARK: - Internal Methods
private extension QuickVerseManager {
    func getLocalizationsFor(languageCode: String, completion: @escaping (_ success: Bool) ->()) {
        if QuickVerseManager.shared.isDebugEnabled {
            LoggingManager.log("ℹ️ Retrieving localizations for language code: \(languageCode)")
        }
        localizationManager.getLocalizationsFor(languageCode: languageCode) { result in
            switch result {
            case .success(let localizationResponse):
                
                let localizations = localizationResponse.data.localisations
                if localizations.isEmpty {
                    LoggingManager.log("🚨 WARN: Localizations empty. Please add at least one localization entry to your account on quickverse.io.")
                }
                if QuickVerseManager.shared.isDebugEnabled {
                    LoggingManager.logCodeForAvailableLocalizations(localizations)
                }
                
                QuickVerseManager.shared.localizations = localizations
                return completion(true)
                
            case .failure(let apiError):
                switch apiError {
                case .noAPIKey:
                    fatalError("🚨 API Key not configured. Please configure the SDK on your app startup (usually AppDelegate) with your API key from https://quickverse.io.")
                case .noBundleID:
                    fatalError("🚨 No bundle ID found. QuickVerse requires a valid Bundle ID to authenticate requests. If this is unexpected, please contact team@quickverse.io.")
                case .invalidURL:
                    fatalError("🚨 Unable to create request url. Please contact team@quickverse.io.")
                case .invalidToken:
                    fatalError("🚨 Unable to generate auth token. Please contact team@quickverse.io.")
                case .noResponse, .noData:
                    LoggingManager.log("🚨 WARN: No response received. Have you added at least one localization in your quickverse.io account?")
                case .unauthorized:
                    LoggingManager.log("🚨 WARN: API Key incorrect, or application has been been added to your quickverse.io account.")
                case .generic(let statusCode):
                    LoggingManager.log("🚨 WARN: Network error. Status code: \(statusCode). Please contact team@quickverse.io if this is unexpected.")
                case .decoding:
                    LoggingManager.log("🚨 WARN: Localizations parse failed. Please contact support at team@quickverse.io.")
                }
                completion(false)
            }
        }
    }
}

extension QuickVerseManager {
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
}

private extension QuickVerseManager {
    func logRequestedKey(_ key: String, defaultValue: String, wasPresent: Bool) {
        if wasPresent {
            reportingManager.logUtilisedKey(key)
        } else {
            if localizations.isEmpty {
                LoggingManager.log("🚨 WARN: No localizations have been received. Have you added at least one localization to your quickverse account? If yes, did your fetchLocaliZations request succeed?")
            } else {
                LoggingManager.log("🚨 WARN: Value not found for referenced key: \(key). Please check this key exists in your quickverse.io account.")
            }
            reportingManager.logMissingKey(key, defaultValue: defaultValue)
        }
    }
}
