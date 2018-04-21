
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectCRUD

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
                    resError(request, response, error: "roomno 参数不正确")
                    return
                }

                let roomTable = db.table(Room.self)
                let qurey = try roomTable
                    .where(\Room.room_no == roomno && \Room.state == true)
                    .select().map {$0}

                var roomArray: [[String: Any]] = []

                for row in qurey {
                    var roomdict: [String: Any] = [:]
                    roomdict["id"] = row.id
                    roomdict["state"] = row.state
                    roomdict["room_no"] = row.room_no
                    roomdict["rent_money"] = row.rent_money
                    roomdict["deposit"] = row.deposit
                    roomdict["lease_term"] = row.lease_term
                    roomdict["rent_date"] = row.rent_date
                    roomdict["network"] = row.network
                    roomdict["trash_fee"] = row.trash_fee
                    roomArray.append(roomdict)
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

