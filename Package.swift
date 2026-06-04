// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "echofm",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "echofm", targets: ["echofm"]),
    ],
    targets: [
        .target(
            name: "echofm",
            path: "src"
        ),
    ]
)
