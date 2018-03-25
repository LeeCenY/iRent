
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM


/// 查询房间住户信息
public class RoomNo: BaseHandler {
    /// 查询房间住户信息
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func queryRoomNo() -> RequestHandler{
        return {
            request, response in
            do {
                guard let roomno = request.param(name: "roomno") else {
                    error(request, response, error: "roomno 参数不正确")
                    return
                }
                
                let room = Room()
                try room.find(["room_no": roomno])
                
                var roomArray: [[String: Any]] = []
                for row in room.rows() {
                    roomArray.append(row.asDetailDict() as [String: Any])
                }
                
                try response.setBody(json: ["success": true, "status": 200, "data": roomArray])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "queryRoomNo : \(error)")
            }
        }
    }
}


