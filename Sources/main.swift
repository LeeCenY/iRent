import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// 路由
var  routes = makeWebDemoRoutes()
// HTTP服务器
let server = ConfigServer()

server.addRoutes(routes)

do {
    //启动服务器
    try server.start()
} catch {
    fatalError("\(error)")
}

