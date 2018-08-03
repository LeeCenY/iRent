import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectThread
import PerfectRepeater

////初始化数据库
try db().create(Room.self, policy: .reconcileTable)
try db().create(Tenant.self, policy: .reconcileTable)
try db().create(Payment.self, policy: .reconcileTable)
try db().create(User.self, policy: .reconcileTable)


//定时备份数据库
Repeater.exec(timer: 86400) { () -> Bool in
    Threading.getQueue(type: .concurrent).dispatch {
        DBBackup().start()
    }
    return true
}

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

