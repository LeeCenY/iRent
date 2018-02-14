
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
            guard let fullname: String = dict["fullname"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "fullname 请求参数不正确"])
                response.completed()
                return
            }
            //手机号
            guard let phonenumber: String = dict["phonenumber"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "phonenumber 请求参数不正确"])
                response.completed()
                return
            }
            //身份证
            guard let idcardnumber: String = dict["idcardnumber"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "idcardnumber 请求参数不正确"])
                response.completed()
                return
            }
            //房间号
            guard let roomnumber: String = dict["roomnumber"]  as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "roomnumber 请求参数不正确"])
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
            guard let renttime: Int = dict["renttime"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "renttime 请求参数不正确"])
                response.completed()
                return
            }
            //租金
            guard  let rent: String = dict["rent"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "rent 请求参数不正确"])
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
            guard let internetfee: Bool = dict["internetfee"] as? Bool else {
                try response.setBody(json: ["success": false, "status": 200, "data": "internet 请求参数不正确"])
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
            guard let electric: String = dict["electric"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "electric 请求参数不正确"])
                response.completed()
                return
            }
            //月份
            guard let month: String = dict["month"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "month 请求参数不正确"])
                response.completed()
                return
            }
            
            let roomNumber = RoomNumber()
            roomNumber.uuid            = UUID.init().string
            roomNumber.roomnumber      = roomnumber
            roomNumber.leaseterm       = leaseterm
            roomNumber.rent            = rent
            roomNumber.deposit         = deposit
            roomNumber.renttime        = renttime
            roomNumber.internetfee     = internetfee ? 1 : 0
            roomNumber.trashfee        = trashfee ? 1 : 0
            
            let tenants = Tenants()
            tenants.fullname        = fullname
            tenants.idcardnumber    = idcardnumber
            tenants.phonenumber     = phonenumber
            
            let electricMeters = ElectricMeters()
            electricMeters.electricmeter_month = month
            electricMeters.electricmeter_number = electric
            
            let watermeters = WaterMeters()
            watermeters.watermeter_month = month
            watermeters.watermeter_number = water
            
            let rentStatus = RentStatus()
            rentStatus.rent_month = month
            rentStatus.rent_received = "0"
            
            try roomNumber.save { id in
                roomNumber.id = id as! Int
            }
            
            tenants.roomnumber_id = roomNumber.id
            try tenants.save { id in
                tenants.id = id as! Int
            }
            
            electricMeters.roomnumber_id = roomNumber.id
            electricMeters.tenants_id = tenants.id
            try electricMeters.save { id in
                electricMeters.id = id as! Int
            }
            
            watermeters.roomnumber_id = roomNumber.id
            watermeters.tenants_id = tenants.id
            try watermeters.save { id in
                watermeters.id = id as! Int
            }
            
            rentStatus.roomnumber_id = roomNumber.id
            rentStatus.tenants_id = tenants.id
            try rentStatus.save { id in
                rentStatus.id = id as! Int
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
