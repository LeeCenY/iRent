import Foundation
import PerfectLib
import PerfectHTTPServer
import PerfectCrypto
import PerfectCRUD
import PerfectMySQL
import PerfectNotifications

/// HTTPServer 服务器配置
///
/// - Returns: 返回server
public func ConfigServer() -> HTTPServer {
    let server = HTTPServer()
    server.serverName = "127.0.0.1"
    server.serverPort = 8350
    return server
}

/// Database 数据库配置
///
/// - Returns: 返回Database<MySQLDatabaseConfiguration>
public func db() -> Database<MySQLDatabaseConfiguration> {
    
    let host = "localhost"
    let user = "root"
    let password = "123456789"
    let DB = "test"
    let port = 3306
    
    let mySQL = MySQL()
    //自动重连
    mySQL.setOption(.MYSQL_OPT_RECONNECT, 1)
    //数据库中包含非ascii码，比如中文
    mySQL.setOption(.MYSQL_SET_CHARSET_NAME, "utf8")
    //创建连接
    let isConnect = mySQL.connect(host: host, user: user, password: password, db: DB, port: UInt32(port), socket: nil, flag: 0)
    guard isConnect else {
        print(mySQL.errorMessage())
        return db()
    }
    return Database(configuration: MySQLDatabaseConfiguration.init(connection: mySQL))
}


/// 七牛 key and token
public struct QiniuConfig {
    
    let SK = "在七牛上注册账号分配"
    let AK = "在七牛上注册账号分配"
    let scope = "空间名"

    func getToken(day: TimeInterval) throws -> String? {
        
        let deadline = Date().timeIntervalSince1970 + day * 24 * 3600
        let putPolicy: [String : Any] = ["scope": scope,"deadline": Int(deadline)]
        
        let jsonData = try putPolicy.jsonEncodedString()
        guard let encodeString = String.init(validatingUTF8: jsonData.encode(.base64)!)?.urlSafeBase64() else {
            return nil
        }
        guard let encodedSignString = String(validatingUTF8:(encodeString.sign(.sha1, key: HMACKey.init(SK))?.encode(.base64))!)?.urlSafeBase64() else {
            return nil
        }
        return "\(AK):\(encodedSignString):\(encodeString)"
    }
}

public struct Pusher {
    
    // App Bundle Id
    let notificationsAppId = "com.App.BundleId"
    //key ID
    let apnsKeyIdentifier = "KeyId"
    //Team ID
    let apnsTeamIdentifier = "TeamId"
    //.p8 key File Path
    let apnsPrivateKeyFilePath = "./AuthKey_KeyId.p8"
    
    init() {
        NotificationPusher.addConfigurationAPNS(name: notificationsAppId, production: false, keyId: apnsKeyIdentifier, teamId: apnsTeamIdentifier, privateKeyPath: apnsPrivateKeyFilePath)
    }
    
    func pushAPNS(deviceTokens: [String],
                  notificationItems: [APNSNotificationItem],
                  callback: @escaping ([NotificationResponse]) -> ()) {
        
        NotificationPusher
            .init(apnsTopic: notificationsAppId)
            .pushAPNS(configurationName: notificationsAppId, deviceTokens: deviceTokens, notificationItems: notificationItems, callback: callback)
    }
}

