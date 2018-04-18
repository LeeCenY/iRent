
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectCRUD

/// 抄表
public class ExpiredRent: BaseHandler {
    /// 抄表
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    static func update() -> RequestHandler {
        return {
            request, response in
            do {
                guard
                    let json = request.postBodyString,
                    let dict = try json.jsonDecode() as? [String: Any]
                    else {
                        error(request, response, error: "请填写请求参数")
                        return
                }
                //id
                guard let id = UUID.init(uuidString: (dict["id"] as? String)!) else {
                    error(request, response, error: "id 请求参数不正确")
                    return
                }
                
                //收租时间
                guard let rentDate: String = dict["rent_date"] as? String, rentDate.toDate() != nil else {
                    error(request, response, error: "收租时间 rentdate 请求参数不正确")
                    return
                }
                
                
                //水表数
                guard let water: Int = dict["water"] as? Int else {
                    error(request, response, error: "水表数 water 请求参数不正确")
                    return
                }
                //电表数
                guard let electricity: Int = dict["electricity"] as? Int else {
                    error(request, response, error: "电表数 electricity 请求参数不正确")
                    return
                }
                
                let roomTable = db.table(Room.self)
                let query = roomTable.where(\Room.id == id)
                
                guard try query.count() != 0 else {
                    error(request, response, error: "房间 id 不存在")
                    return
                }

                //TODO 还需要判断时间
                
                let paymentTable = db.table(Payment.self)
                
                let payment = Payment.init(id: UUID(), room_id: UUID(), state: false, payee: "", rent_date: rentDate, money: 100, rent_money: 0, water: water, electricity: electricity, network: 999, trash_fee:999, arrears: 999, remark: "", create_at: Date(), updated_at: Date())
//                payment.rent_date       = rentDate
//                payment.water           = water
//                payment.electricity     = electricity
//                payment.state           = false
//                payment.updated_at      = Date()
                
                try paymentTable
                    .where(\Payment.room_id == id && \Payment.rent_date == rentDate)
                    .update(payment, setKeys: \.rent_date, \.water, \.electricity, \.state, \.updated_at)
                

                try response.setBody(json: ["success": true, "status": 200, "data": "更新成功"])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "update : \(error)")
            }
        }
    }
    
}

