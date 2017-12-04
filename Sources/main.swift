import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let _ = ConfigMySql()

let roomNumberSetup = RoomNumber()
try! roomNumberSetup.setup()

let tenantsSetup = Tenants()
try! tenantsSetup.setup()

let electricMetersSetup = ElectricMeters()
try! electricMetersSetup.setup()

let watermetersSetup = WaterMeters()
try! watermetersSetup.setup()

let rentStatusSetup = RentStatus()
try! rentStatusSetup.setup()

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

