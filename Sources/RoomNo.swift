
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
            
            let roomNumber = RoomNumber()
            try roomNumber.find(queryRoomNo)
            
            var roomNumberArray: [[String: Any]] = []
            for row in roomNumber.rows() {
                roomNumberArray.append(row.asDetailDict() as [String: Any])
            }
            
            try response.setBody(json: ["success": true, "status": 200, "data": roomNumberArray])
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "queryRoomNo : \(error)")
        }
        
    }
    
}


