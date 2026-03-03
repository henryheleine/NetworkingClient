// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkingClient",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkingClient",
            targets: ["NetworkingClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/shineRR/pingx", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkingClient",
            dependencies: [
                .product(name: "pingx", package: "pingx")
            ]
        ),
        .testTarget(
            name: "NetworkingClientTests",
            dependencies: ["NetworkingClient"]
        ),
    ]
)
