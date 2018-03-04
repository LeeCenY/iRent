
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM


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
            guard let name: String = dict["name"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "name 请求参数不正确"])
                response.completed()
                return
            }
            //手机号
            guard let phone: String = dict["phone"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "phone 请求参数不正确"])
                response.completed()
                return
            }
            //身份证
            guard let idcard: String = dict["idcard"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "idcard 请求参数不正确"])
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
            guard let leaseterm: String = dict["leaseterm"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "leaseterm 请求参数不正确"])
                response.completed()
                return
            }
            //收租时间
            guard let rentdate: Int = dict["rentdate"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "rentdate 请求参数不正确"])
                response.completed()
                return
            }
            //租金
            guard  let rentmeony: String = dict["rentmeony"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "rentmeony 请求参数不正确"])
                response.completed()
                return
            }
            //押金
            guard   let deposit: String = dict["deposit"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "deposit 请求参数不正确"])
                response.completed()
                return
            }
            //网费
            guard let network: Bool = dict["network"] as? Bool else {
                try response.setBody(json: ["success": false, "status": 200, "data": "network 请求参数不正确"])
                response.completed()
                return
            }
            //垃圾费
            guard let trashfee: Bool = dict["trashfee"] as? Bool else {
                try response.setBody(json: ["success": false, "status": 200, "data": "trashfee 请求参数不正确"])
                response.completed()
                return
            }
            //水表
            guard let water: String = dict["water"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "water 请求参数不正确"])
                response.completed()
                return
            }
            //电表
            guard let electricity: String = dict["electricity"] as? String else {
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
            room.rent_date      = rentdate
            room.network        = network ? 1 : 0
            room.trash_fee      = trashfee ? 1 : 0
            
            let tenant = Tenant()
            tenant.name         = name
            tenant.idcard       = idcard
            tenant.phone        = phone
            
            let payment = Payment()
            payment.month       = month
            payment.water       = water
            payment.electricity = electricity
            payment.network     = network ? 1 : 0
            payment.trash_fee   = trashfee ? 1 : 0
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
