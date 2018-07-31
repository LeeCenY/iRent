// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "iRent",
    dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.17"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", from: "3.2.0"),
        .package(url: "https://github.com/MatthewYork/DateTools.git", from: "4.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-Notifications.git", from: "3.0.3"),
        .package(url: "https://github.com/LeeCenY/Perfect-Qiniu.git", from: "1.0.2"),
        ],
    targets: [
        .target(
            name: "iRent",
            dependencies: [
                "PerfectHTTPServer",
                "PerfectMySQL",
                "DateToolsSwift",
                "PerfectNotifications",
                "PerfectQiniu"]
        ),
    ]
)
