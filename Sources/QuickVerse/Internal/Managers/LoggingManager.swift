struct LoggingManager {
    static func log(_ string: String) {
        print("QuickVerse: \(string)")
    }
    static func logCodeForAvailableLocalizations(_ localizations: [QuickVerseLocalization]) {
        var casesString = ""
        for (index, localization) in localizations.enumerated() {
            let propertyName = localization.key.replacingOccurrences(of: ".", with: "_")
            casesString.append("static let \(propertyName) = \"\(localization.key)\"")
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
        
        Example: QuickVerse.stringFor(key: QVKey.\(localizations.last?.key.replacingOccurrences(of: " .,-", with: "", options: [.regularExpression]) ?? ""))
        
        ℹ️ℹ️ℹ️ DEBUG: END AVAILABLE LOCALIZATION KEYS ℹ️ℹ️ℹ️
        """
        LoggingManager.log(logString)
    }
}
