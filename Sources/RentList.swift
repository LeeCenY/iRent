
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM

/// 收租信息列表
public class RentList {
    /// 收租信息列表
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func rentlist(_ request: HTTPRequest, _ response: HTTPResponse) {
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
            
            let roomNumber = RoomNumber()
            let cursor = StORMCursor.init(limit: limit, offset: offset)
            //从数据库获取数据
            try roomNumber.select(columns: [], whereclause: "id", params: [], orderby: [], cursor: cursor, joins: [], having: [], groupBy: [])
            
            var roomNumberArray: [[String: Any]] = []
            
            
            if listType == "expire" {
                for row in roomNumber.rows() {
                    
                    let date = row._tenants[0].create_time.date()!
                    let leasedTime = row._tenants.count
                    let dateCompareRange = isDateCompareRange(date: date, leasedTime: leasedTime, rangeDay: 5)
                    
                    if (!dateCompareRange) {
                        break
                    }
                    roomNumberArray.append(row.asHomeDict() as [String : Any])
                }
            }else {
                for row in roomNumber.rows() {
                    roomNumberArray.append(row.asHomeDict() as [String : Any])
                }
            }

            try response.setBody(json: ["success": true, "status": 200, "data": roomNumberArray])
//            response.setHeader(.contentType, value: "appliction/json")
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "rentlist : \(error)")
        }
        
    }
    
    

   
    //账单状态
    open static func receive(_ request: HTTPRequest, _ response: HTTPResponse) {
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
            guard let billingStatus: String = dict["received"] as? String else {
                try response.setBody(json: ["success": false, "status": 200, "data": "received 请求参数不正确"])
                response.completed()
                return
            }

            let rentStatusObj = RentStatus()
            try rentStatusObj.update(cols: ["rent_month","rent_received","update_time"],
                                     params: [month, billingStatus, Date().string()],
                                     idName: "id",
                                     idValue: id)

            try response.setBody(json: ["success": true, "status": 200, "data": "已收账单"])
            response.completed()
        } catch {
            try! response.setBody(json: ["success": false, "status": 200])
            response.completed()
            Log.error(message: "update : \(error)")
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


