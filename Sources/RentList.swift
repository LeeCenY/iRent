
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM


/// 收租信息列表
public class RentList {
    /// 收租信息列表
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func rentlist(_ request: HTTPRequest, _ response: HTTPResponse) {
        do {
            
            var offset = 0
            if let page = request.param(name: "page") {
                offset = Int(page)!
                offset = (offset - 1) * 2
            }
            
            let tenants = Tenants()
            let s = StORMCursor.init(limit: 2, offset: offset)
            
            try tenants.select(columns: [], whereclause: "id", params: [], orderby: [], cursor: s, joins: [], having: [], groupBy: [])
            
            var tenantsArray: [[String: Any]] = []
            for row in tenants.rows() {
                tenantsArray.append(row.asDict() as [String : Any])
            }
            
            try response.setBody(json: ["success": true, "status": 200, "data": tenantsArray])
            response.setHeader(.contentType, value: "appliction/json")
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "rentlist : \(error)")
        }
        
    }

    
}
