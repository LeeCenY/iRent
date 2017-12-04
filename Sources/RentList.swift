
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
            
            let roomNumber = RoomNumber()
            let s = StORMCursor.init(limit: 20, offset: offset)
            //从数据库获取数据
            try roomNumber.select(columns: [], whereclause: "id", params: [], orderby: [], cursor: s, joins: [], having: [], groupBy: [])
            
            var roomNumberArray: [[String: Any]] = []
            for row in roomNumber.rows() {
                roomNumberArray.append(row.asHomeDict() as [String : Any])
            }
            
            try response.setBody(json: ["success": true, "status": 200, "data": roomNumberArray])
//            response.setHeader(.contentType, value: "appliction/json")
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "rentlist : \(error)")
        }
        
    }

    
}
