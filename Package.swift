// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Intro",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "Onboarding", targets: ["Onboarding"])
    ],
    targets: [
        .target(
            name: "Onboarding",
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
