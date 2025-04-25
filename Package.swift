// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PartnerOneSDK",
    defaultLocalization: "pt",
    products: [
        .library(name: "PartnerOneSDK", targets: ["PartnerOneSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/acesso-io/unico-check-ios.git", .upToNextMajor(from: "2.16.12"))
    ],
    targets: [
        .target(
            name: "PartnerOneSDK",
            dependencies: [
                .product(name: "unicocheck-ios-spm", package: "unico-check-ios")
            ],
            resources: [
                .process("Resources")
            ]
        )
//        .testTarget(name: "PartnerOneSDKTests", dependencies: ["PartnerOneSDK"])
    ]
)
