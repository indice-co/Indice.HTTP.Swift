// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkUtilities",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "NetworkUtilities",
            targets: ["NetworkUtilities"]
        ),
    ],
    targets: [
        .target(
            name: "NetworkUtilities",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "NetworkUtilitiesTests",
            dependencies: ["NetworkUtilities"]
        )
    ]
)
