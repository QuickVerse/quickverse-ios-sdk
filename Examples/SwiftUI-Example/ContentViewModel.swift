//
//  ContentViewModel.swift
//  SwiftUI-Example
//
//  Created by QuickVerse on 06/05/2023.
//

import QuickVerse
import SwiftUI

class ContentViewModel: ObservableObject {
    
    private let demoLanguages = ["es", "it", "fr", "de", "en"]
    private var demoLanguageIndex = 0
    
    @Published var titleText: String?
    @Published var bodyText: String?
    @Published var resultSourceText = String()
    
    func getDeviceLanguageLocalizations() {
        QuickVerse.getLocalizations { [weak self] success in
            // Update loading state / UI
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateLocalizedText()
                self.resultSourceText = "Using: System Language (\(QuickVerse.retrieveDeviceLanguageCode().prefix(2)))"
            }
        }
    }
    func getDemoLanguageLocalizations() {
        let demoLanguageCode = demoLanguages[demoLanguageIndex]
        if demoLanguageIndex == demoLanguages.count - 1 {
            demoLanguageIndex = 0
        } else {
            demoLanguageIndex += 1
        }
        
        QuickVerse.getSpecificLocalizations(languageCode: demoLanguageCode) { [weak self] success in
            // Update loading state / UI
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateLocalizedText()
                self.resultSourceText = "Using: Demo Language (\(demoLanguageCode))"
            }
        }
    }
    private func updateLocalizedText() {
        // Access values using the keys you declared in your quickverse.io account
        titleText = QuickVerse.stringFor(key: "Onboarding.Demo.Title")
        
        // Strongly Recommended - Use a centrally-declared keys file, such as QVKey - seen here
        titleText = QuickVerse.stringFor(key: QVKey.onboardingDemoTitle)
        
        // Optionally use our compact accessor "QV"
        titleText = QV.stringFor(key: QVKey.onboardingDemoTitle)
        
        // Optionally provide a default value
        titleText = QV.stringFor(key: QVKey.onboardingDemoTitle, defaultValue: "Welcome to QuickVerse!")
        
        // Optionally provide a substitution
        titleText = QV.stringFor(key: QVKey.onboardingDemoTitleWithUser,
                                 substitutions: [QVSubstitution(replace: "%@", with: "Alice")])
        
        bodyText = QV.stringFor(key: QVKey.onboardingDemoBody)
    }
}
