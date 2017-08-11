import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let _ = ConfigMySql()

let tenantsSetup = Tenants()
try! tenantsSetup.setup()

let electricMetersSetup = ElectricMeters()
try! electricMetersSetup.setup()

let watermeters = Watermeters()
try! watermeters.setup()


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

