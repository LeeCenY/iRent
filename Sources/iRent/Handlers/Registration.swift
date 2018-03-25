
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM
import SwiftMoment

/// 登记信息
public class Registration: BaseHandler  {
    /// 登记信息
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    static func tenant() -> RequestHandler {
        return {
            request, response in
            do {
                guard
                    let json:           String              = request.postBodyString,
                    let dict:           [String: Any]       = try json.jsonDecode()             as? [String: Any]
                    else {
                        error(request, response, error: "请填写请求参数")
                        return
                }
                
                //姓名
                let name = dict["name"] as? String ?? ""
                //身份证
                let idcard = dict["idcard"] as? String ?? ""
                //网费
                let network = dict["network"] as? Int ?? 0
                //垃圾费
                let trashfee = dict["trashfee"] as? Int ?? 0
                
                //手机号
                guard let phone: String = dict["phone"] as? String, phone.count == 11 else {
                    error(request, response, error: "手机号码 phone 请求参数不正确")
                    return
                }
                
                //房间号
                guard let roomno: String = dict["roomno"]  as? String else {
                    error(request, response, error: "房间号 roomno 请求参数不正确")
                    return
                }
                //租期
                guard let leaseterm: Int = dict["leaseterm"] as? Int else {
                    error(request, response, error: "租期 leaseterm 请求参数不正确")
                    return
                }
                //收租时间
                guard let rentdate: String = dict["rentdate"] as? String, (moment(rentdate)?.date) != nil else {
                    error(request, response, error: "收租时间 rentdate 请求参数不正确")
                    return
                }
                //租金
                guard  let rentmeony: Int = dict["rentmeony"] as? Int  else {
                    error(request, response, error: "租金 rentmeony 请求参数不正确")
                    return
                }
                //押金
                guard   let deposit: Int = dict["deposit"] as? Int else {
                    error(request, response, error: "押金 deposit 请求参数不正确")
                    return
                }
                
                //水表
                guard let water: Int = dict["water"] as? Int else {
                    error(request, response, error: "水表 water 请求参数不正确")
                    return
                }
                //电表
                guard let electricity: Int = dict["electricity"] as? Int else {
                    error(request, response, error: "电表 electricity 请求参数不正确")
                    return
                }
                //月份
                guard let month: String = dict["month"] as? String, moment(month, dateFormat: DateFormat.month) != nil else {
                    error(request, response, error: "月份 month 请求参数不正确")
                    return
                }
                
                
                
                let room = Room()
                room.uuid           = UUID.init().string
                room.room_no        = roomno
                room.lease_term     = leaseterm
                room.rent_money     = rentmeony
                room.deposit        = deposit
                room.rent_date      = (moment(rentdate)?.date)!
                room.network        = network
                room.trash_fee      = trashfee
                
                let tenant = Tenant()
                tenant.name         = name
                tenant.idcard       = idcard
                tenant.phone        = phone
                
                let payment = Payment()
                payment.month       = month
                payment.water       = water
                payment.electricity = electricity
                payment.network     = network
                payment.trash_fee   = trashfee
                payment.state       = 0
                
                
                //查询这房间是否已经退了
                try room.save { id in
                    room.id = id as! Int
                }
                
                tenant.room_id = room.id
                try tenant.save { id in
                    tenant.id = id as! Int
                }
                
                payment.room_id = room.id
                try payment.save { id in
                    payment.id = id as! Int
                }
                
                try response.setBody(json: ["success": true, "status": 200, "data": "登记信息成功"])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "registration : \(error)")
            }
        }
    }

}
