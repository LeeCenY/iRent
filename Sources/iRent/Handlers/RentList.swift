
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM
import SwiftMoment

/// 收租信息列表
public class RentList {
    /// 收租信息列表
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func rentlist() -> RequestHandler {
        return {
            request, response in
            do {
                
                var offset = 0
                var limit = 20
                if let page = request.param(name: "page") {
                    offset = Int(page)!
                    offset = (offset - 1) * 2
                }
                
                var listType = "all"
                if let type = request.param(name: "type") {
                    listType = type
                }
                
                if listType == "expire" {
                    offset = 0
                    limit = 100
                }
                
                let room = Room()
                let cursor = StORMCursor.init(limit: limit, offset: offset)
                //从数据库获取数据
                try room.select(columns: [], whereclause: "id", params: [], orderby: [], cursor: cursor, joins: [], having: [], groupBy: [])
                
                var roomArray: [[String: Any]] = []
                
                
                if listType == "expire" {
                    //                for row in room.rows() {
                    //
                    //                    let date = row.create_at
                    //                    row.
                    //                    let leasedTime = row.tenant.count - 1
                    //                    let dateCompareRange = isDateCompareRange(date: date, leasedTime: leasedTime, rangeDay: 7)
                    //
                    //                    if (!dateCompareRange) {
                    //                        break
                    //                    }
                    //                    roomArray.append(row.asHomeDict() as [String : Any])
                    //                }
                }else {
                    for row in room.rows() {
                        roomArray.append(row.asHomeDict() as [String : Any])
                    }
                }
                
                try response.setBody(json: ["success": true, "status": 200, "data": roomArray])
                response.setHeader(.contentType, value: "appliction/json")
                response.completed()
            } catch {
                try! response.setBody(json: ["success": false, "status": 200])
                response.completed()
                Log.error(message: "rentlist : \(error)")
            }
        }
    }
    
    //账单状态
    open static func receive() -> RequestHandler {
        return {
            request, response in
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
                
                //账单状态
                guard let state: Bool = dict["state"] as? Bool else {
                    try response.setBody(json: ["success": false, "status": 200, "data": "state 请求参数不正确"])
                    response.completed()
                    return
                }
                
                let stateInt = state ? 1 : 0
                let payment = Payment()
                let updateState = try payment.update(cols: ["month","state","updated_at"],
                                                     params: [month, stateInt, Date().string()],
                                                     idName: "room_id",
                                                     idValue: id)
                
                try response.setBody(json: ["success": true, "status": 200, "data": updateState])
                response.completed()
            } catch {
                try! response.setBody(json: ["success": false, "status": 200])
                response.completed()
                Log.error(message: "update : \(error)")
            }
        }
    }
    
    // 获取详情信息
    open static func details() -> RequestHandler {
        return {
            request, response in
            do {
                
                guard let room_id = request.param(name: "room_id") else {
                    try response.setBody(json: ["success": false, "status": 200, "data": "room_id 参数不正确"])
                    response.completed()
                    return
                }
                
                guard let month = request.param(name: "month") else {
                    try response.setBody(json: ["success": false, "status": 200, "data": "month 参数不正确"])
                    response.completed()
                    return
                }
                
                let payment = Payment()
                let month2 = moment(month.toDate("yyyyMM")!).subtract(1, TimeUnit.Months).format("yyyyMM")
                
                try payment.select(whereclause: "room_id = ? and month between ? and ? ", params: [room_id, month2, month], orderby: ["month DESC"])
                
                var paymentDict = [String: Any]()
                for (index, row) in payment.rows().enumerated() {
                    if (index == 0) {
                        paymentDict = row.asDetailDict()
                        continue
                    }
                    if (index == 1) {
                        paymentDict["lastWater"] = row.water
                        paymentDict["lastElectricity"] = row.electricity
                        break
                    }
                }
                
                try response.setBody(json: ["success": true, "status": 200, "data": paymentDict])
                response.completed()
                
            } catch {
                try! response.setBody(json: ["success": false, "status": 200])
                response.completed()
                Log.error(message: "details : \(error)")
            }
        }
    }
    
    // 退房
    open static func checkOut() -> RequestHandler {
        return {
            request, response in
            do {
                
                guard let room_id = request.param(name: "room_id") else {
                    try response.setBody(json: ["success": false, "status": 200, "data": "room_id 参数不正确"])
                    response.completed()
                    return
                }
                
                let stateInt = 1
                
                let room = Room()
                try room.update(cols: ["state"], params: [stateInt], idName: "id", idValue: room_id)
                
                let tenant = Tenant()
                try tenant.update(cols: ["state"], params: [stateInt], idName: "room_id", idValue: room_id)
                
                try response.setBody(json: ["success": true, "status": 200, "data": "退房成功"])
                response.completed()
            } catch {
                try! response.setBody(json: ["success": false, "status": 200])
                response.completed()
                Log.error(message: "details : \(error)")
            }
        }
    }
}

enum ListType {
    case All
    case Range
}

func isDateCompareRange(date: Date, leasedTime: Int, rangeDay: Int)-> Bool{
    let dateFrom = calculateDate(day: -rangeDay)
    let dateTo = calculateDate(day: rangeDay)
    let currentDate = calculateDate(date: date, month: leasedTime)
    return (currentDate?.compare(dateFrom!) == .orderedDescending && currentDate?.compare(dateTo!) == .orderedAscending);
}


