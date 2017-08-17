
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM


/// 查询房间住户信息
public class RoomNo {
    /// 查询房间住户信息
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func queryRoomNo(_ request: HTTPRequest, _ response: HTTPResponse) {
        do {
            guard let roomnumber = request.param(name: "roomnumber") else {
                try response.setBody(json: ["success": false, "status": 200, "data": "roomnumber 参数不正确"])
                response.completed()
                return
            }
            
            var queryRoomNo = [String: Any]()
            queryRoomNo.updateValue(roomnumber, forKey: "roomnumber")
            
            let tenants = Tenants()
            try tenants.find(queryRoomNo)
            
            var tenantsArray: [[String: Any]] = []
            for row in tenants.rows() {
                tenantsArray.append(row.asDict() as [String: Any])
            }
            
            try response.setBody(json: ["success": true, "status": 200, "data": tenantsArray])
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "queryRoomNo : \(error)")
        }
        
    }
    
}


