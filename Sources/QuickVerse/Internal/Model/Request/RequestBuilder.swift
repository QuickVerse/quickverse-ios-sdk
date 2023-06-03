import Foundation

struct RequestBuilder {
    static func buildLocalizationRequest(languageCodes: [String]) -> String {
        return RequestEndpoint.base + RequestType.localizations.path + languageCodes.joined(separator: ",")
    }
    static func buildAnalyticsRequest() -> String {
        return RequestEndpoint.base + RequestType.reporting.path
    }
}
