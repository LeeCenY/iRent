import PackageDescription

let package = Package(
    name: "iRent",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/SwiftORM/MySQL-StORM", majorVersion: 1, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 1),
    ]
)
