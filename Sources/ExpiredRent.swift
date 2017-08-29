
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM


/// 到期收租
public class ExpiredRent {
    /// 到期收租
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func update(_ request: HTTPRequest, _ response: HTTPResponse) {
        do {
            guard
                let json = request.postBodyString,
                let dict = try json.jsonDecode() as? [String: Any]
                else {
                    try response.setBody(json: ["success": false, "status": 200, "data": "请填写请求参数"])
                    response.completed()
                    return
            }
            
            guard let id: Int = dict["id"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "id 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let month: String = dict["month"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "month 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let water: String = dict["water"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "water 请求参数不正确"])
                response.completed()
                return
            }
            
            guard let electric: String = dict["electric"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "electric 请求参数不正确"])
                response.completed()
                return
            }
            
            let waterObj = WaterMeters()
            let electricObj = ElectricMeters()
            
            try waterObj.select(whereclause: "tenants_id = ? AND watermeter_month = ?",
                                params: [id, month],
                                orderby: [])
            try electricObj.select(whereclause: "tenants_id = ? AND electricmeter_month = ?",
                                   params: [id, month],
                                   orderby: [])
            
            if waterObj.rows().count != 0,
                electricObj.rows().count != 0 {
                try response.setBody(json: ["success": false, "status": 200, "data": "本月已更新"])
                response.completed()
                return
            }
            
            waterObj.tenants_id = id
            waterObj.watermeter_month    = month
            waterObj.watermeter_number   = water
            
            electricObj.tenants_id = id
            electricObj.electricmeter_month   = month
            electricObj.electricmeter_number  = electric
            
            let water_insert =  try waterObj.insert(
                cols: ["tenants_id",
                       "watermeter_month",
                       "watermeter_number",
                       "create_time",
                       "update_time"],
                params: [waterObj.tenants_id,
                         waterObj.watermeter_month,
                         waterObj.watermeter_number,
                         waterObj.create_time,
                         waterObj.update_time]
            )
            
            let electric_insert =  try electricObj.insert(
                cols: ["tenants_id",
                       "electricmeter_month",
                       "electricmeter_number",
                       "create_time",
                       "update_time"],
                params: [electricObj.tenants_id,
                         electricObj.electricmeter_month,
                         electricObj.electricmeter_number,
                         electricObj.create_time,
                         electricObj.update_time]
            )
            
            try response.setBody(json: ["success": true, "status": 200, "data":
                [
                    "electric_id": electric_insert,
                    "water_id": water_insert
                ]])
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "update : \(error)")
        }
    }

}

