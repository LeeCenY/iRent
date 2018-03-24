import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

//初始化数据库
DataBaseConnect.setup()

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

