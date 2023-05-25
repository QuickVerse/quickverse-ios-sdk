import Foundation

/**
 We always recommend declaring your keys centrally in their own file, instead of accessing by key inline.
 You can then use something like: QuickVerse.stringFor(key: QVKey.onboardingDemoTitle)
*/

class QVKey {
    static let onboardingDemoTitle = "Onboarding.Demo.Title"
    static let onboardingDemoTitleWithUser = "Onboarding.Demo.TitleWithUser"
    static let onboardingDemoBody = "Onboarding.Demo.Body"
}
