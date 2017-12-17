import PackageDescription

let package = Package(
    name: "iRent",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        .Package(url: "https://github.com/SwiftORM/MySQL-StORM.git", majorVersion: 3),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 3),
    ]
)
