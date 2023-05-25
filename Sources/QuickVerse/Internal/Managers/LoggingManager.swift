struct LoggingManager {
    static func log(_ string: String) {
        print("QuickVerse: \(string)")
    }
    static func logCodeForAvailableLocalizations(_ localizations: [QuickVerseLocalization]) {
        var casesString = ""
        for (index, localization) in localizations.enumerated() {
            casesString.append("static let \(clean(key: localization.key)) = \"\(localization.key)\"")
            if index != localizations.count - 1 {
                casesString.append("\n\t")
            }
        }
        let logString = """
        ℹ️ℹ️ℹ️ START AVAILABLE LOCALIZATION KEYS ℹ️ℹ️ℹ️
        
        Paste this class in your code, and use it to access the QuickVerse values you have created in your quickverse.io account.
        
        class QVKey {
            \(casesString)
        }
        
        Example: QuickVerse.stringFor(key: QVKey.\(clean(key: localizations.last?.key ?? "")))
        
        ℹ️ℹ️ℹ️ DEBUG: END AVAILABLE LOCALIZATION KEYS ℹ️ℹ️ℹ️
        """
        LoggingManager.log(logString)
    }
    // Removes characters from the key to provide a property name that Xcode will accept.
    private static func clean(key: String) -> String {
        return key
            .replacingOccurrences(of: "[ ._,-]", with: "", options: .regularExpression)
            .lowercasingFirstLetter()
    }
}
