// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "NetworkManager",
    products: [
        .library(name: "NetworkManager", targets: ["NetworkManager"]),
    ],
    dependencies: [
        .package(
            url: "git@github.com:nekonora/LogManager.git",
            from: "1.0.0"
        )],
    targets: [
        .target(name: "NetworkManager", dependencies: ["LogManager"]),
        .testTarget(name: "NetworkManagerTests", dependencies: ["NetworkManager"]),
    ]
)
