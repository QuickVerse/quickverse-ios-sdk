import Foundation

struct RequestBuilder {
    static func buildLocalizationRequest(languageCode: String) -> String {
        return RequestEndpoint.base + RequestType.localizations.path + languageCode
    }
    static func buildAnalyticsRequest() -> String {
        return RequestEndpoint.base + RequestType.reporting.path
    }
}
