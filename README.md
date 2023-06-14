[![Version](https://img.shields.io/static/v1?label=pod&message=1.4.6&color=blue&style=flat)](#cocoapods)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-success.svg?style=flat)](#Swift-Package-Manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-success.svg?style=flat)](#carthage)
[![Twitter](https://img.shields.io/twitter/follow/quickverse_io?style=social)](https://twitter.com/quickverse_io)

# QuickVerse iOS SDK

QuickVerse makes mobile & web app localization a breeze. Migrate your web and mobile localizations to QuickVerse Cloud, and start managing them anytime, anywhere, collaboratively.

1. [Installation](#installation)
    1. [Swift Package Manager](#swift-package-manager) 
    2. [Cocoapods](#cocoapods)
    3. [Carthage](#carthage)
2. [Usage](#usage)
    1. [Import the SDK](#1-import-the-sdk)
    2. [Configure the SDK](#2-configure-the-sdk-on-app-launch)
    3. [Retrieve your QuickVerse localizations](#3-retrieve-your-quickverseio-localizations)
    4. [Access your localizations](#4-access-your-localized-strings)
3. [Logging & Troubleshooting](#logging--troubleshooting)
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
pod 'QuickVerse', '~> 1.4.6' // Or pin to a specific version
```
2. In a terminal window, navigate to the directory of your `Podfile`, and run `pod install --repo-update`

### Carthage

We recommend integrating with SPM or CocoaPods, but please contact us for integration guidance if you wish to use Carthage.

## Usage

QuickVerse is a very lightweight integration, requiring just a few lines of code.

### 1. Import the SDK

```swift
import QuickVerse
```

### 2. Configure the SDK on app launch

You'll need your APIKey, retrievable from your QuickVerse account [here](https://quickverse.io/project/default/applications).

- For UIKit, place in `didFinishLaunchingWithOptions` in AppDelegate.swift
- For SwiftUI, we recommend placing in the initialiser for your app, as shown [here](https://stackoverflow.com/a/62562934)
```swift
QuickVerse.configure(apiKey: "{your-api-key}")
QuickVerse.isDebugEnabled = true // Optionally get detailed console logs
```

### 3. Retrieve your QuickVerse.io localizations

In most cases, you'll want to download the localizations during your launch sequence - before any copy is shown to the user.
```swift
QuickVerse.getLocalizations { [weak self] success in
    // Continue into app or handle failure
}
```
_Note_: Keep an eye on the console. If you enable `isDebugEnabled`, the QuickVerse SDK will print out all available keys from your [quickverse.io](https://quickverse.io/project/default/localisations) account.

### 4. Access your localized strings

```swift
yourlabel.text = QuickVerse.stringFor(key: "Onboarding_Demo_Title")
```

Optionally provide a default value, should the key not exist in the local store.
```swift
yourlabel.text = QuickVerse.stringFor(key: "Onboarding_Demo_Title", defaultValue: "Welcome to QuickVerse")
```

**_Recommended_**: Although you _can_ access the keys "inline", as showed above, we strongly recommend you store your keys in a single file for easy maintenance.
If you enable `isDebugEnabled`, the SDK will print out a copy-able struct to the console, with all keys in your [quickverse.io](https://quickverse.io/project/default/localisations) account.
```swift
class QVKey {
    static let onboardingDemoTitle = "Onboarding.Demo.Title"
    static let onboardingDemoBody = "Onboarding.Demo.Body"
}
```
You can then access your localized strings without hardcoding keys:
```swift
yourlabel.text = QuickVerse.stringFor(key: QVKey.onboardingDemoTitle)
```
If you update this regularly, it will also help reduce bugs, for example if you were referencing a key that was later removed from quickverse.io.
Note: if you have keys in your QuickVerse.io account that uses symbols iOS doesn't accept in variable names (any of: .,-), they'll be replaced with underscores when logged above (only the property names of course, the values will match the server value). 

## Logging & Troubleshooting

All QuickVerse console logs start with "QuickVerse: " for easy filtering. We recommend setting `QuickVerse.isDebugEnabled = true` during setup, and any time you're adding new keys.

### Informational Logs:
- "START AVAILABLE LOCALIZATION KEYS" - logs an auto-generated struct of available keys for you to copy into your application.
- "Retrieving localizations for language code" - informs you which language localizations will be fetched for. Useful for testing.

### Troubleshooting Logs:
- "API Key not configured" - have you called `QuickVerse.configure(apiKey: "{your-api-key}")` on app launch, before you try to fetch localizations?
- "API Key incorrect" - have you added your application to [quickverse.io](https://quickverse.io/project/default/applications), and are you using the correct APIKey for the current Bundle ID? QuickVerse APIkeys are specific to bundle IDs.
- "No response received" / "Localizations empty" - have you added at least one localization to your [quickverse.io](https://quickverse.io/project/default/localisations) account?

Missing logs? Make sure you're setting `QuickVerse.isDebugEnabled = true` when you configure the SDK.

## FAQs

1. How big is your SDK? The final binary size of the QuickVerse iOS SDK is very small, just 0.01MB, or 10kb!
2. How does your SDK handle limited connectivity? Our SDK requests all localizations on launch and caches them, so if there's limited connectivity later in the session, the localizations will still work.
3. What kind of data does the SDK collect and how is it used? The only data our SDK transmits off the device is: language keys for translations, SDK version, and device type.
4. Can we request changes? Absolutely! Please share your requests with us at team@quickverse.io and we'll review and get back to you.

## Support

Got a query or need support? We're always on hand to help with your integration & beyond. Just ping us at team@quickverse.io and we'll get back to you within your QuickVerse plan's SLA.
