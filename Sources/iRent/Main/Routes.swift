import PerfectLib
import PerfectHTTP

/// 路由接口
///
/// - Returns: 返回路由
public func makeWebDemoRoutes() -> [Route] {
    
    var routeArray = [Route]()
    // 登记信息
    routeArray.append(Route(method: .post, uri: "registration", handler: Registration.tenant()))
    // 收租信息列表
    routeArray.append(Route(method: .get, uri: "rentlist", handler: RentList.rentlist()))
    // 获取详情信息
    routeArray.append(Route(method: .get, uri: "details", handler: RentList.details()))
    // 收到房租
    routeArray.append(Route(method: .post, uri: "receive", handler: RentList.receive()))
    // 更新住户信息
    routeArray.append(Route(method: .post, uri: "update", handler: ExpiredRent.update()))
    // 修改住户信息
    routeArray.append(Route(method: .post, uri: "change", handler: ExpiredRent.change()))
    // 退房
    routeArray.append(Route(method: .get, uri: "checkout", handler: RentList.checkOut()))
    // 查询住户信息
    routeArray.append(Route(method: .get, uri: "roomquery", handler: RoomNo.queryRoomNo()))
    // 七牛token
    routeArray.append(Route(method: .get, uri: "qiniutoken", handler: Qiniu.qiniutoken()))
    // 添加七牛图片URL
    routeArray.append(Route(method: .post, uri: "imageurl", handler: Qiniu.qiniuImageURL()))
    
    return routeArray
}



