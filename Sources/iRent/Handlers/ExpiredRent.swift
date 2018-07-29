
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
                        resError(request, response, error: "请填写请求参数")
                        return
                }
                //id
                guard let id = UUID.init(uuidString: (dict["id"] as? String)!) else {
                    resError(request, response, error: "id 请求参数不正确")
                    return
                }
                
                //收租时间
                guard let rentDate: String = dict["rent_date"] as? String, rentDate.toDate() != nil else {
                    resError(request, response, error: "收租时间 rentdate 请求参数不正确")
                    return
                }
                
                //水表数
                guard let water: Int = dict["water"] as? Int else {
                    resError(request, response, error: "水表数 water 请求参数不正确")
                    return
                }
                //电表数
                guard let electricity: Int = dict["electricity"] as? Int else {
                    resError(request, response, error: "电表数 electricity 请求参数不正确")
                    return
                }
                
                let roomTable = db().table(Room.self)
                let query = roomTable.where(\Room.id == id)
                
                guard try query.count() != 0 else {
                    resError(request, response, error: "房间 id 不存在")
                    return
                }
                
                var rent_money = Int()
                var network = Int()
                var trash_fee = Int()
                
                for row in try query.select() {
                    rent_money = row.rent_money!
                    network = row.network!
                    trash_fee = row.trash_fee!
                }
                
                let paymentTable = db().table(Payment.self)
                let queryCount = try paymentTable
                    .where(\Payment.room_id == id && \Payment.rent_date == rentDate)
                    .count()
                
                //先 insert 本月信息
                if queryCount == 0  {
                    let payment = Payment.init(room_id: id, state: false, payee: nil, rent_date: rentDate, money: nil, rent_money: rent_money, water: nil, electricity: nil, network: network, trash_fee: trash_fee, image_url: nil, arrears: nil, remark: nil)
                    
                    try paymentTable.insert(payment)
                }
                
                
                //TODO 还需要判断时间
                
                let payment = Payment.init(room_id: UUID(), state: false, payee: nil, rent_date: rentDate, money: nil, rent_money: rent_money, water: water, electricity: electricity, network: network, trash_fee:trash_fee, image_url: nil, arrears: nil, remark: nil)
                
                
                try paymentTable
                    .where(\Payment.room_id == id && \Payment.rent_date == rentDate)
                    .update(payment, ignoreKeys: \.id, \.room_id, \.create_at, \.money)
                
                try response.setBody(json: ["success": true, "status": 200, "data": "更新成功"])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "update : \(error)")
            }
        }
    }
    
    /// 修改
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    static func change() -> RequestHandler {
        return {
            request, response in
            do {
                guard
                    let json = request.postBodyString,
                    let dict = try json.jsonDecode() as? [String: Any]
                    else {
                        resError(request, response, error: "请填写请求参数")
                        return
                }
                //id
                guard let id = UUID.init(uuidString: (dict["id"] as? String)!) else {
                    resError(request, response, error: "id 请求参数不正确")
                    return
                }
                
                //租金
                guard  let rentMeony: Int = dict["rentmeony"] as? Int, rentMeony > 0 else {
                    resError(request, response, error: "租金 rentmeony 请求参数不正确")
                    return
                }
                
                //押金
                guard  let deposit: Int = dict["deposit"] as? Int, rentMeony > 0 else {
                    resError(request, response, error: "押金 deposit 请求参数不正确")
                    return
                }
                
                //水表阈值
                guard let waterMax: Int = dict["water_max"] as? Int else {
                    resError(request, response, error: "水表阈值 water_max 请求参数不正确")
                    return
                }
                
                //电表阈值
                guard let electricityMax: Int = dict["electricity_max"] as? Int else {
                    resError(request, response, error: "电表阈值 electricity_max 请求参数不正确")
                    return
                }
                
                //网络
                guard let network: Int = dict["network"] as? Int else {
                    resError(request, response, error: "网络 network 请求参数不正确")
                    return
                }
                
                //垃圾费
                guard let trashfee: Int = dict["trashfee"] as? Int else {
                    resError(request, response, error: "垃圾费 trashfee 请求参数不正确")
                    return
                }
                
                let roomTable = db().table(Room.self)
                let query = roomTable.where(\Room.id == id && \Room.state == false)
                
                guard try query.count() != 0 else {
                    resError(request, response, error: "房间 id 不存在或已经退房")
                    return
                }

                let room = Room(state: false, room_no: nil, rent_money: rentMeony, deposit: deposit, lease_term: nil, rent_date: nil, network: network, trash_fee: trashfee, water_max: waterMax, electricity_max: electricityMax)
                
                do {
                    try roomTable
                        .where(\Room.id == id && \Room.state == false)
                        .update(room, ignoreKeys: \.id, \.room_no, \.lease_term, \.rent_date, \.create_at)
                } catch {
                    try response.setBody(json: ["success": true, "status": 400, "data": "\(error)"])
                    response.completed()
                    return
                }
                
                try response.setBody(json: ["success": true, "status": 200, "data": "修改成功"])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "update : \(error)")
            }
        }
    }
    
}

