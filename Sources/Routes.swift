import PerfectLib
import PerfectHTTP

/// 路由接口
///
/// - Returns: 返回路由
public func makeWebDemoRoutes() -> Routes {
    var routes = Routes()

    // 登记信息
    routes.add(method: .post, uri: "/registration", handler: WebHandlers.registration)
    
    // 收租信息列表
    routes.add(method: .get, uri: "/rentlist", handler: WebHandlers.rentlist)
   
    //查询住户信息
    routes.add(method: .get, uri: "/cc", handler: WebHandlers.update)
    
    return routes
}



