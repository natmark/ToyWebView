// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToyWebView",
    platforms: [
        .iOS("14.5"),
        .macOS("10.15"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ToyWebView",
            targets: ["ToyWebView"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "git@github.com:davedufresne/SwiftParsec.git", from: "4.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ToyWebView",
            dependencies: ["SwiftParsec"],
            exclude: ["ToyWebViewExample"]),
        .testTarget(
            name: "ToyWebViewTests",
            dependencies: ["ToyWebView"],
            exclude: ["ToyWebViewExample"]),
    ]
)
