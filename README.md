[![Version](https://img.shields.io/cocoapods/v/QuickVerse?style=flat)](#cocoapods)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-success.svg?style=flat)](#Swift-Package-Manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-success.svg?style=flat)](#carthage)
[![Twitter](https://img.shields.io/twitter/follow/quickverse_io?style=social)](https://twitter.com/quickverse.io)

# QuickVerse iOS SDK

QuickVerse makes mobile & web app localization a breeze. Migrate your web and mobile localizations to QuickVerse Cloud, and start managing them anytime, anywhere, collaboratively.

1. [Installation](#installation)
    1. [Swift Package Manager](#Swift-Package-Manager) 
    2. [Cocoapods](#cocoapods)
    3. [Carthage](#carthage)
2. [Usage](#usage)
3. [Logging & Troubleshooting](#Logging-&-Troubleshooting)
5. [FAQs](#faqs)
6. [Support](#support)

## Installation

### Swift Package Manager

1. Select File » Add Packages... and enter the repository URL of the package https://github.com/QuickVerse/quickverse-ios-sdk.git into the search bar (top right).
2. Set the Dependency Rule to Up to next major, and the version number to 1.0.0 < 2.0.0.
3. Ensure "QuickVerse" when a prompt for "Choose Package Products for quickverse-ios-sdk" appears. Finally, choose the target where you want to use it.

The library should have been added to the Swift Package Dependencies section, and you'll now be able to import it in the files where you need it.

### CocoaPods

1. Add the following to your Podfile. If you don't already have a Podfile, run `pod init` in your project's root directory:

```
pod 'QuickVerse' // Always use the latest version
pod 'QuickVerse', '~> 1.3.1' // Or pin to a specific version
```
2. In a terminal window, navigate to the directory of your `Podfile`, and run `pod install`

### Carthage

We recommend SPM for CocoaPods, but please contact us for integration guidance if you wish to use Carthage.

## Usage

QuickVerse is a very lightweight integration, requiring just a few lines of code.

1. In files where you wish to use QuickVerse localizations, import the QuickVerse SDK you just installed.
```Swift
import QuickVerse
```
2. Configure the QuickVerse SDK in AppDelegate.swift. To do this, you need your APIKey, retrievable from your QuickVerse account [here](https://quickverse.io/project/default/applications).
```Swift
QuickVerse.shared.configure(apiKey: "{your-api-key}")
QuickVerse.shared.isDebugEnabled = true // Optionally get detailed console logs
```

3. Download the localizations, typically during your launch sequence.
```Swift
QuickVerse.shared.getLocalizations { [weak self] success in
    // Continue into app
}
```
_Note_: Keep an eye on the console. If you enable `isDebugEnabled`, the QuickVerse SDK will print out all available keys from your [quickverse.io](https://quickverse.io/project/default/localisations) account.

4. Access your localized strings - from anywhere in your app.
```Swift
text = QuickVerse.shared.stringFor(key: "Onboarding_Demo_Title")
```

Optionally provide a default value, should the key not exist in the local store.
```Swift
text = QuickVerse.shared.stringFor(key: "Onboarding_Demo_Title", defaultValue: "Welcome to QuickVerse")
```

**_Recommended_**: Although you _can_ access the keys "inline", as showed above, we strongly recommend you store your keys in a single file for easy maintenance.
If you enable `isDebugEnabled`, the SDK will print out a copy-able struct to the console, with all keys in your [quickverse.io](https://quickverse.io/project/default/localisations) account:
```Swift
// QuickVerse: ℹ️ℹ️ℹ️ START AVAILABLE LOCALIZATION KEYS ℹ️ℹ️ℹ️

// Paste this class in your code, and use it to access the QuickVerse values you have created in your quickverse.io account.

class QVKey {
    static let Onboarding_Demo_Body = "Onboarding.Demo.Body"
	static let Onboarding_Demo_Title = "Onboarding.Demo.Title"
}

```
You can then access your localized strings without hardcoding keys:
```Swift
text = QuickVerse.shared.stringFor(key: QVKey.Onboarding_Demo_Body)
```
If you update this regularly, it will also help reduce bugs, for example if you were referencing a key that was later removed from quickverse.io.

## Logging & Troubleshooting

All QuickVerse console logs start with "QuickVerse: " for easy filtering. We recommend setting `QuickVerse.shared.isDebugEnabled = true` during setup, and any time you're adding new keys.

### Informational Logs:
- "START AVAILABLE LOCALIZATION KEYS" - logs an auto-generated struct of available keys for you to copy into your application.
- "Retrieving localizations for language code" - informs you which language localizations will be fetched for. Useful for testing.

### Troubleshooting Logs:
- "API Key not configured" - have you called `QuickVerse.shared.configure(apiKey: "{your-api-key}")` on app launch, before you try to fetch localizations?
- "API Key incorrect" - have you added your application to [quickverse.io](https://quickverse.io/project/default/applications), and are you using the correct APIKey for the current Bundle ID? QuickVerse APIkeys are specific to bundle IDs.
- "No response received" / "Localizations empty" - have you added at least one localization to your [quickverse.io](https://quickverse.io/project/default/localisations) account?

Missing logs? Make sure you're setting `QuickVerse.shared.isDebugEnabled = true` when you configure the SDK.

## FAQs

1. How big is your SDK? The final binary size of the QuickVerse iOS SDK is very small, just 0.2MB.
2. How does your SDK handle limited connectivity? Our SDK requests all localizations on launch and caches them, so if there's limited connectivity later in the session, the localizations will still work.
3. What kind of data does the SDK collect and how is it used? The only data our SDK transmits off the device is: language keys for translations, SDK version, and device type.
4. Can we request changes? Absolutely! Please share your requests with us at team@quickverse.io and we'll review and get back to you.

## Support

Got a query or need support? We're always on hand to help with your integration & beyond. Just ping us at team@quickverse.io and we'll get back to you within the SLAs timeline associated with your QuickVerse plan.
