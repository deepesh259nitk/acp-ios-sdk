// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACP-iOS-SDK",
    platforms: [
            .iOS(.v13) // <-- required for async/await
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ACP-iOS-SDK",
            targets: ["ACP-iOS-SDK"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ACP-iOS-SDK"
        ),
        .testTarget(
            name: "ACP-iOS-SDKTests",
            dependencies: ["ACP-iOS-SDK"]
        ),
    ]
)
