// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SprogalVectorGraphics",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(name: "SprogalVectorGraphics", targets: ["SprogalVectorGraphics"]),
    ],
    dependencies: [
        .package(url: "https://github.com/samatarcuriye/sprogal.git", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "SprogalVectorGraphics",
            dependencies: [
                .product(name: "Sprogal", package: "sprogal"),
            ]
        ),
    ]
)

