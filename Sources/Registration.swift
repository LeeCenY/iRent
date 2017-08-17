
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
            
            guard let idcardnumber: String = dict["idcardnumber"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "idcardnumber 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let phonenumber: String = dict["phonenumber"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "phonenumber 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let roomnumber: String = dict["roomnumber"]  as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "roomnumber 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let leaseterm: String = dict["leaseterm"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "leaseterm 请求参数不正确"])
                response.completed()
                return
            }
            
            guard  let rent: String = dict["rent"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "rent 请求参数不正确"])
                response.completed()
                return
            }
            
            guard   let deposit: String = dict["deposit"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "deposit 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let renttime: Int = dict["renttime"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "renttime 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let internet: Bool = dict["internet"] as? Bool else {
                try response.setBody(json: ["success": false, "status": 200, "data": "internet 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let trashfee: Bool = dict["trashfee"] as? Bool else {
                try response.setBody(json: ["success": false, "status": 200, "data": "trashfee 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let water: Int = dict["water"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "water 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let electric: Int = dict["electric"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "electric 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let month: String = dict["month"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "month 请求参数不正确"])
                response.completed()
                return
            }
            
            let tenants = Tenants()
            tenants.uuid            = UUID.init().string
            tenants.idcardnumber    = idcardnumber
            tenants.phonenumber     = phonenumber
            tenants.roomnumber      = roomnumber
            tenants.leaseterm       = leaseterm
            tenants.rent            = rent
            tenants.deposit         = deposit
            tenants.renttime        = renttime
            tenants.internet        = internet ? 1 : 0
            tenants.trashfee        = trashfee ? 1 : 0
            
            
            let electricMeters = ElectricMeters()
            electricMeters.electricmeter_month = month
            electricMeters.electricmeter_number = electric
            
            let watermeters = WaterMeters()
            watermeters.watermeter_month = month
            watermeters.watermeter_number = water
            
            
            try tenants.save { id in
                tenants.id = id as! Int
            }
            
            electricMeters.tenants_id = tenants.id
            try electricMeters.save { id in
                electricMeters.id = id as! Int
            }
            
            watermeters.tenants_id = tenants.id
            try watermeters.save { id in
                watermeters.id = id as! Int
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
