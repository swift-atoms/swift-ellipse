// swift-tools-version: 6.4
import PackageDescription
let package = Package(
    name: "swift-ellipse",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Ellipse", targets: ["Ellipse"])],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-magnitude.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-rotation.git", branch: "main"),
    ],
    targets: [
        .target(name: "Ellipse", dependencies: [
            .product(name: "Magnitude", package: "swift-magnitude"),
            .product(name: "Rotation", package: "swift-rotation"),
        ]),
        .testTarget(name: "Ellipse Tests", dependencies: [.target(name: "Ellipse")]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
