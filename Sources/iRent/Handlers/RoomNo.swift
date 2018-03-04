
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
            guard let roomno = request.param(name: "roomno") else {
                try response.setBody(json: ["success": false, "status": 200, "data": "roomno 参数不正确"])
                response.completed()
                return
            }
            
            var queryRoomNo = [String: Any]()
            queryRoomNo["room_no"] = roomno
            
            let room = Room()
            try room.find(queryRoomNo)
            
            var roomArray: [[String: Any]] = []
            for row in room.rows() {
                roomArray.append(row.asDetailDict() as [String: Any])
            }
            
            try response.setBody(json: ["success": true, "status": 200, "data": roomArray])
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "queryRoomNo : \(error)")
        }
        
    }
    
}


