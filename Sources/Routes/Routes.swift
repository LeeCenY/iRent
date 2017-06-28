import PerfectLib
import PerfectHTTP

/// 路由接口
///
/// - Returns: 返回路由
public func makeWebDemoRoutes() -> Routes {
    var routes = Routes()
    // 收租信息列表
    routes.add(method: .get, uri: "/rentInformation", handler: WebHandlers.rentInformationGet(request:response:))
    // 登记信息
    routes.add(method: .post, uri: "/registration", handler: WebHandlers.registrationPost(request:response:))
    
    return routes
}
