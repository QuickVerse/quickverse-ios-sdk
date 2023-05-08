struct QuickVerseLogger {
    static func logStatement(_ string: String) {
        print("QuickVerse: \(string)")
    }
    static func printCodeForAvailableLocalizations(_ localizations: [QuickVerseLocalization]) {
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
        
        Example: QuickVerse.shared.stringFor(key: QVKey.\(localizations.last?.key.replacingOccurrences(of: ".", with: "_") ?? ""))
        
        ℹ️ℹ️ℹ️ DEBUG: END AVAILABLE LOCALIZATION KEYS ℹ️ℹ️ℹ️
        """
        QuickVerseLogger.logStatement(logString)
    }
}
