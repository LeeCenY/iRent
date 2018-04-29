import PerfectLib
import PerfectHTTPServer

/// HTTPServer 服务器配置
///
/// - Returns: 返回server
public func ConfigServer() -> HTTPServer {
    let server = HTTPServer()
    server.serverName = "127.0.0.1"
    server.serverPort = 8350
    return server
}

//public func ConfigMySql() {
//    MySQLConnector.host        = "127.0.0.1"
//    MySQLConnector.username    = "root"
//    MySQLConnector.password    = "123456789"
//    MySQLConnector.database    = "test"
//    MySQLConnector.port        = 3306
//}

//class DataBaseConnect {
//    static func setup() {
//        MySQLConnector.host        = "127.0.0.1"
//        MySQLConnector.username    = "root"
//        MySQLConnector.password    = "123456789"
//        MySQLConnector.database    = "test"
//        MySQLConnector.port        = 3306
//
//        self.setTable()
//    }
//
//    private static func setTable() {
//        setupTable(storm: Room())
//        setupTable(storm: Tenant())
//        setupTable(storm: Payment())
//    }
//
//    private static func setupTable(storm: MySQLStORM){
//        do {
//            try storm.setupTable()
//        } catch  {
//            print(("\(storm.table())表初始化失败"))
//        }
//    }
//}

