//
//  SwiftUIExampleApp.swift
//  SwiftUI-Example
//
//  Created by QuickVerse on 01/05/2023.
//

import SwiftUI
import QuickVerse

@main
struct SwiftUIExampleApp: App {
    init() {
        // Create an account on https://quickverse.io to generate an API key for your organisation/application
        QuickVerse.shared.configure(apiKey: "")
        QuickVerse.shared.isDebugEnabled = true
    }
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
