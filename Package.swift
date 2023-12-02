// swift-tools-version: 5.9

import PackageDescription

let BaseMindGateway: Target = .target(
    name: "BaseMindGateway",
    dependencies: [
        .product(name: "GRPC", package: "grpc-swift"),
        .product(name: "NIOCore", package: "swift-nio"),
        .product(name: "NIOPosix", package: "swift-nio"),
        .product(name: "SwiftProtobuf", package: "swift-protobuf")
    ]
)

let package = Package(
    name: "BaseMind",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "BaseMindClient",
            targets: ["BaseMindClient"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.6.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.15.0")
    ],
    targets: [
        BaseMindGateway,
        .target(
            name: "BaseMindClient",
            dependencies: ["BaseMindGateway"]
        ),
        .testTarget(
            name: "BaseMindClientTests",
            dependencies: ["BaseMindClient"]
        )
    ]
)
