import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMySQL
import PerfectCRUD

//初始化数据库
let db = Database(configuration: try MySQLDatabaseConfiguration(database: "test", host: "localhost", port: 3306, username: "root", password: "123456789"))
try db.create(Room.self, policy: .reconcileTable)
try db.create(Tenant.self, policy: .reconcileTable)
try db.create(Payment.self, policy: .reconcileTable)


//API版本
let api = "api"
let version = "v1"
let baseUri = api + "/" + version + "/"

// HTTP服务器
let server = ConfigServer()
server.addRoutes(Routes.init(baseUri: baseUri, routes: makeWebDemoRoutes()))

do {
    //启动服务器
    try server
        .setResponseFilters([(Filter404(),.high)])
        .start()
} catch {
    fatalError("\(error)")
}

