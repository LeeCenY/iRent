import PerfectLib
import PerfectHTTP
import PerfectHTTPServer


// HTTP服务器
let server = ConfigServer()
server.addRoutes(makeWebDemoRoutes())


do {
    //启动服务器
    try server
        .setResponseFilters([(Filter404(),.high)])
        .start()
} catch {
    fatalError("\(error)")
}

