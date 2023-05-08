//
//  ViewController.swift
//  UIKit-Example
//
//  Created by QuickVerse on 05/05/2023.
//

import UIKit
import QuickVerse

class ViewController: UIViewController {
    
    private let onboardingTitleLabel = UILabel()
    private let onboardingBodyLabel = UILabel()
    
    private let resultSourceLabel = UILabel()
    private let changeSystemLanguageButton = UIButton(type: .system)
    private let useSystemLanguageButton = UIButton(type: .system)
    private let cycleDemoLanguagesButton = UIButton(type: .system)
    
    private let demoLanguages = ["es", "it", "fr", "de", "en"]
    private var demoLanguageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // This request would typically be in your launch sequence (before you need to display any copy) - such as a loading interstitial, and usually only once per session
        getDeviceLanguageLocalizations()
    }
}

private extension ViewController {
    func getDeviceLanguageLocalizations() {
        QuickVerse.shared.getLocalizations { [weak self] success in
            guard let self else { return }
            DispatchQueue.main.async {
                if success {
                    self.updateLocalizedText()
                    self.resultSourceLabel.text = "Using: System Language (\(QuickVerse.shared.retrieveDeviceLanguageCode().prefix(2)))"
                } else {
                    // Handle error
                }
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
        
        QuickVerse.shared.getSpecificLocalizations(languageCode: demoLanguageCode) { [weak self] success in
            guard let self else { return }
            DispatchQueue.main.async {
                if success {
                    self.updateLocalizedText()
                    self.resultSourceLabel.text = "Using: Demo Language (\(demoLanguageCode))"
                } else {
                    // Handle error
                }
            }
        }
    }
    func updateLocalizedText() {
        // Strongly Recommended - Use a centrally-declared keys file, such as QVKey - seen here
        self.onboardingTitleLabel.text = QuickVerse.shared.stringFor(key: QVKey.Onboarding_Demo_Title)
        // Alternatively, keys can be hardcoded "inline"
        self.onboardingBodyLabel.text = QuickVerse.shared.stringFor(key: "Onboarding.Demo.Body")
    }
}

private extension ViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        setupResultOutputUI()
        setupResultControlsUI()
    }
    
    func setupResultOutputUI() {
        [onboardingTitleLabel, onboardingBodyLabel, resultSourceLabel].forEach { label in
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
        }
        
        [resultSourceLabel, onboardingBodyLabel].forEach { $0.textColor = Brand.Colors.lightGrey.uiColor }
        [onboardingTitleLabel].forEach { $0.textColor = Brand.Colors.darkGrey.uiColor }
        
        onboardingTitleLabel.font = Fonts.lexendMedium(size: 20)
        onboardingBodyLabel.font = Fonts.lexendRegular(size: 14)
        resultSourceLabel.font = Fonts.lexendMedium(size: 14)
        
        onboardingTitleLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            onboardingTitleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -60),
            onboardingTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
        onboardingBodyLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            onboardingBodyLabel.topAnchor.constraint(equalTo: onboardingTitleLabel.bottomAnchor, constant: 8),
            onboardingBodyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            onboardingBodyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
        ])
    }
    
    func setupResultControlsUI() {
        changeSystemLanguageButton.setTitle("Change", for: [])
        useSystemLanguageButton.setTitle("Use System Language", for: [])
        cycleDemoLanguagesButton.setTitle("Cycle Demo Languages", for: [])
        
        view.addSubview(changeSystemLanguageButton)
        changeSystemLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        
        [cycleDemoLanguagesButton, useSystemLanguageButton].forEach { button in
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.backgroundColor = Brand.Colors.primary.uiColor
            button.setTitleColor(.white, for: [])
            button.titleLabel?.font = Fonts.lexendMedium(size: 14)
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
        }
        
        NSLayoutConstraint.activate([
            cycleDemoLanguagesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            cycleDemoLanguagesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            cycleDemoLanguagesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            changeSystemLanguageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            changeSystemLanguageButton.heightAnchor.constraint(equalToConstant: 50),
            changeSystemLanguageButton.widthAnchor.constraint(equalToConstant: 60),
            changeSystemLanguageButton.bottomAnchor.constraint(equalTo: cycleDemoLanguagesButton.topAnchor, constant: -8),
            
            useSystemLanguageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            useSystemLanguageButton.trailingAnchor.constraint(equalTo: changeSystemLanguageButton.leadingAnchor, constant: -12),
            useSystemLanguageButton.bottomAnchor.constraint(equalTo: changeSystemLanguageButton.bottomAnchor)
        ])
        changeSystemLanguageButton.setTitleColor(Brand.Colors.primary.uiColor, for: [])
        changeSystemLanguageButton.titleLabel?.font = Fonts.lexendMedium(size: 14)
        
        cycleDemoLanguagesButton.addTarget(self, action: #selector(cycleDemoLanguagesTapped), for: .touchUpInside)
        useSystemLanguageButton.addTarget(self, action: #selector(useSystemLanguageTapped), for: .touchUpInside)
        changeSystemLanguageButton.addTarget(self, action: #selector(changeSystemLanguageTapped), for: .touchUpInside)
        
        [resultSourceLabel].forEach { label in
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.textColor = Brand.Colors.lightGrey.uiColor
        }
        
        NSLayoutConstraint.activate([
            resultSourceLabel.bottomAnchor.constraint(equalTo: useSystemLanguageButton.topAnchor, constant: -24),
            resultSourceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            resultSourceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
    }
    
    @objc func cycleDemoLanguagesTapped() {
        getDemoLanguageLocalizations()
    }
    
    @objc func useSystemLanguageTapped() {
        getDeviceLanguageLocalizations()
    }
    @objc func changeSystemLanguageTapped() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
