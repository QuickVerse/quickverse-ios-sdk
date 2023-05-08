// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuickVerse",
    products: [
        .library(
            name: "QuickVerse",
            targets: ["QuickVerse"]),
    ],
    targets: [
        .target(
            name: "QuickVerse",
            dependencies: []),
        .testTarget(
            name: "QuickVerseTests",
            dependencies: ["QuickVerse"]),
    ]
)
