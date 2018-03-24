
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM
import SwiftMoment

/// 登记信息
public class Registration {
    /// 登记信息
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func tenant(_ request: HTTPRequest, _ response: HTTPResponse) {
        do {
            guard
                let json:           String              = request.postBodyString,
                let dict:           [String: Any]       = try json.jsonDecode()             as? [String: Any]
                else {
                    try response.setBody(json: ["success": false, "status": 200, "data": "请填写请求参数"])
                    response.completed()
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
            guard let phone: String = dict["phone"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "phone 请求参数不正确"])
                response.completed()
                return
            }

            //房间号
            guard let roomno: String = dict["roomno"]  as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "roomno 请求参数不正确"])
                response.completed()
                return
            }
            //租期
            guard let leaseterm: Int = dict["leaseterm"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "leaseterm 请求参数不正确"])
                response.completed()
                return
            }
            //收租时间
            guard let rentdate: String = dict["rentdate"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "rentdate 请求参数不正确"])
                response.completed()
                return
            }
            //租金
            guard  let rentmeony: Int = dict["rentmeony"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "rentmeony 请求参数不正确"])
                response.completed()
                return
            }
            //押金
            guard   let deposit: Int = dict["deposit"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "deposit 请求参数不正确"])
                response.completed()
                return
            }
        
            //水表
            guard let water: Int = dict["water"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "water 请求参数不正确"])
                response.completed()
                return
            }
            //电表
            guard let electricity: Int = dict["electricity"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "electricity 请求参数不正确"])
                response.completed()
                return
            }
            //月份
            guard let month: String = dict["month"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "month 请求参数不正确"])
                response.completed()
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
            try! response.setBody(json: ["success": false, "status": 200])
                response.completed()
            Log.error(message: "registration : \(error)")
            }
        }
}
