
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
            
            //            let date = Date()
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            
            let tenant = Tenants()
            tenant.id = id
            tenant.updatetime = Date().string()
            
            let electricObj = ElectricMeters()
            electricObj.tenants_id = id
            electricObj.electricmeter_month   = month
            electricObj.electricmeter_number  = electric
            
            let waterObj = WaterMeters()
            waterObj.tenants_id = id
            waterObj.watermeter_month    = month
            waterObj.watermeter_number   = water
            
            
            let tenant_updatetime = try tenant.update(
                cols: ["updatetime"],
                params: [tenant.updatetime],
                idName: "id",
                idValue: tenant.id
            )
            
            let electric_insert =  try electricObj.insert(
                cols: ["tenants_id","electricmeter_month","electricmeter_number"],
                params: [electricObj.tenants_id, electricObj.electricmeter_month, electricObj.electricmeter_number]
            )
            
            let water_insert =  try waterObj.insert(
                cols: ["tenants_id","watermeter_month","watermeter_number"],
                params: [waterObj.tenants_id, waterObj.watermeter_month, waterObj.watermeter_number]
            )
            
            
            try response.setBody(json: ["success": true, "status": 200, "data":
                ["tenant_updatetime": tenant_updatetime,
                 "electric_id": electric_insert,
                 "water_id": water_insert]])
            response.completed()
            
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "update : \(error)")
        }
    }

    
}

