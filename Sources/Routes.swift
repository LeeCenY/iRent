import PerfectLib
import PerfectHTTP

/// 路由接口
///
/// - Returns: 返回路由
public func makeWebDemoRoutes() -> Routes {
    
    let api = "api"
    let version = "v1"
    let prefix = api + "/" + version + "/"

    var routes = Routes.init(baseUri: prefix)

    // 登记信息
    routes.add(method: .post, uri: "registration", handler: WebHandlers.registration)
    // 收租信息列表
    routes.add(method: .get, uri: "rentlist", handler: WebHandlers.rentlist)
    //查询住户信息
    routes.add(method: .get, uri: "update", handler: WebHandlers.update)
    
    return routes
}



