
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM
import SwiftMoment


/// 抄表
public class ExpiredRent {
    /// 抄表
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
            //id
            guard let id: Int = dict["id"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "id 请求参数不正确"])
                response.completed()
                return
            }
            //月份
            guard let month: String = dict["month"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "month 请求参数不正确"])
                response.completed()
                return
            }
            //水表数
            guard let water: Int = dict["water"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "water 请求参数不正确"])
                response.completed()
                return
            }
            //电表数
            guard let electricity: Int = dict["electricity"] as? Int else {
                try response.setBody(json: ["success": false, "status": 200, "data": "electricity 请求参数不正确"])
                response.completed()
                return
            }
            
            let room = Room()
            try room.get(id)
            if room.rows().count == 0 {
                try response.setBody(json: ["success": false, "status": 200, "data": "房间id不存在"])
                response.completed()
                return
            }
            
            let payment = Payment()
            try payment.select(whereclause: "room_id = ? AND month = ?",
                                   params: [id, month],
                                   orderby: [])
 
            if payment.rows().count != 0,
                payment.rows().count != 0 {
                try response.setBody(json: ["success": false, "status": 200, "data": "已经更新过数据"])
                response.completed()
                return
            }

            
            
            payment.room_id         = id
            payment.month           = month
            payment.water           = water
            payment.electricity     = electricity
            payment.state           = 0
            
            let payment_insert =  try payment.insert(
                cols: ["room_id",
                       "state",
                       "month",
                       "water",
                       "electricity",
                       "create_at",
                       "updated_at"],
                params: [payment.room_id,
                         payment.state,
                         payment.month,
                         payment.water,
                         payment.electricity,
                         payment.create_at,
                         payment.updated_at,]
            )

            try response.setBody(json: ["success": true, "status": 200, "data":
                [
                    "payment_id": payment_insert,
                ]])
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "update : \(error)")
        }
    }

}

