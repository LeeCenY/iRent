
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
                    error(request, response, error: "roomno 参数不正确")
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
                        //                    roomdict["create_at"] = row.create_at
                        //                    roomdict["updated_at"] = row.updated_at
                        roomArray.append(roomdict)
                    
                    

//                    "id":               row.id,
//                    "state":            self.state,
//                    "room_no":          self.room_no,
//                    "rent_money":       self.rent_money,
//                    "deposit":          self.deposit,
//                    "lease_term":       self.lease_term,
//                    "rent_date":        self.rent_date,
//                    "network":          self.network,
//                    "trash_fee":        self.trash_fee,
//                    "create_at":        self.create_at,
//                    "updated_at":       self.updated_at
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

