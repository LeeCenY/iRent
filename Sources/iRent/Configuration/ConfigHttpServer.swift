import Foundation
import PerfectLib
import PerfectHTTPServer
import PerfectCrypto

/// HTTPServer 服务器配置
///
/// - Returns: 返回server
public func ConfigServer() -> HTTPServer {
    let server = HTTPServer()
    server.serverName = "127.0.0.1"
    server.serverPort = 8350
    return server
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


