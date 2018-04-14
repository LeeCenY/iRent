
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectCRUD

/// 收租信息列表
public class RentList: BaseHandler {
//    /// 收租信息列表
//    ///
//    /// - Parameters:
//    ///   - request: 请求
//    ///   - response: 响应
//    open static func rentlist() -> RequestHandler {
//        return {
//            request, response in
//            do {
//
//                var offset = 0
//                var limit = 20
//                if let page = request.param(name: "page") {
//                    offset = Int(page)!
//                    offset = (offset - 1) * 2
//                }
//
//                var listType = "all"
//                if let type = request.param(name: "type") {
//                    listType = type
//                }
//
//                if listType == "expire" {
//                    offset = 0
//                    limit = 100
//                }
//
//                let room = Room()
////                let cursor = StORMCursor.init(limit: limit, offset: offset)
//
////                let join = StORMDataSourceJoin.init(table: "Payment", onCondition: "Room.id = Payment.room_id", direction: StORMJoinType.INNER)
////
////                let columns = "room.id, room.uuid, room.state, room.room_no,room.rent_money,room.deposit,room.lease_term,room.rent_date,room.network,room.trash_fee,room.create_at,room.updated_at,payment.water, payment.electricity"
////
////                //从数据库获取数据
////                try room.select(columns: [columns], whereclause: "", params: [], orderby: [], cursor: cursor, joins: [join], having: [], groupBy: [])
//
//                var roomArray: [[String: Any]] = []
//
//                var result = [StORMRow]()
//                if listType == "expire" {
////                    result = try room.sqlRows(
////                        "SELECT Room.id, Room.uuid, Room.state, Room.room_no, Room.rent_money, Room.deposit, Room.lease_term, Room.rent_date, Room.network, Room.trash_fee, Room.create_at, Room.updated_at, Payment.water, Payment.electricity, Payment.state AS payment_state FROM Room INNER JOIN Payment ON Room.id = Payment.room_id WHERE Payment.state = ? AND Room.rent_date >= ? AND Room.rent_date < ? ORDER BY id DESC LIMIT ? OFFSET ?",
////                        params: ["\(0)", "2018-04-01 12:29:58 +0000", "2018-04-10 12:29:58 +0000", "\(limit)", "\(offset)"])
//
//
//                   result = try room.sqlRows(
//                    "SELECT Payment.room_id, Payment.water, Payment.electricity, Payment.state AS payment_state, Room.id, Room.uuid, Room.state, Room.room_no, Room.rent_money, Room.deposit, Room.lease_term, Room.rent_date, Room.network, Room.trash_fee, Room.create_at, Room.updated_at FROM Payment INNER JOIN Room ON Payment.room_id = Room.id WHERE Payment.state = 0 OR Payment.create_at >= ? AND Payment.create_at < ?",
//                        params: ["2018-04-01 12:29:58 +0000", "2018-04-10 12:29:58 +0000"])
//
//                }else {
//
//                    result = try room.sqlRows(
//                        "SELECT Room.id, Room.uuid, Room.state, Room.room_no, Room.rent_money, Room.deposit, Room.lease_term, Room.rent_date, Room.network, Room.trash_fee, Room.create_at, Room.updated_at, Payment.water, Payment.electricity, Payment.state AS payment_state FROM Room INNER JOIN Payment ON Room.id = Payment.room_id ORDER BY id DESC LIMIT ? OFFSET ?",
//                        params: ["\(limit)", "\(offset)"])
//                }
//
//                for row in result {
//                    roomArray.append(row.data)
//                }
//
//                try response.setBody(json: ["success": true, "status": 200, "data": roomArray])
//                response.setHeader(.contentType, value: "application/json")
//                response.completed()
//            } catch {
//                serverErrorHandler(request, response)
//                Log.error(message: "rentlist : \(error)")
//            }
//        }
//    }
//
    //账单状态
    open static func receive() -> RequestHandler {
        return {
            request, response in
            do {
                guard
                    let json = request.postBodyString,
                    let dict = try json.jsonDecode() as? [String: Any]
                    else {
                        error(request, response, error: "请填写请求参数")
                        return
                }
                //id
                guard let id = UUID.init(uuidString: (dict["id"] as? String)!) else {
                    error(request, response, error: "id 请求参数不正确")
                    return
                }
                //收租时间
                guard let rentDate: String = dict["rent_date"] as? String, rentDate.toDate() != nil else {
                    error(request, response, error: "收租时间 rentdate 请求参数不正确")
                    return
                }

                //账单状态
                guard let state: Bool = dict["state"] as? Bool else {
                    error(request, response, error: "账单状态 state 请求参数不正确")
                    return
                }

                
                var payment = Payment()
                payment.state = state
                payment.updated_at = Date()
                
                let paymentTable = db.table(Payment.self)
                try paymentTable
                    .where(\Payment.room_id == id && \Payment.rent_date == rentDate)
                    .update(payment, setKeys: \.state, \.updated_at)

                try response.setBody(json: ["success": true, "status": 200, "data": "收账"])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "update : \(error)")
            }
        }
    }

//    // 获取详情信息
//    open static func details() -> RequestHandler {
//        return {
//            request, response in
//            do {
//
//                guard let room_id = request.param(name: "room_id") else {
//                    error(request, response, error: "room_id 参数不正确")
//                    return
//                }
//
//                //收租时间
//                guard let rentdate = request.param(name: "rentdate"), (moment(rentdate)?.date) != nil else {
//                    error(request, response, error: "收租时间 rentdate 请求参数不正确")
//                    return
//                }
//
//
//                let payment = Payment()
////                let month2 = moment(rentdate.toDate(DateFormat.month).subtract(1, TimeUnit.Months).format(DateFormat.month)
////
////                try payment.select(whereclause: "room_id = ? and month between ? and ? ", params: [room_id, month2, rentdate], orderby: ["month DESC"])
//
//                var paymentDict = [String: Any]()
//                for (index, row) in payment.rows().enumerated() {
//                    if (index == 0) {
//                        paymentDict = row.asDetailDict()
//                        continue
//                    }
//                    if (index == 1) {
//                        paymentDict["lastWater"] = row.water
//                        paymentDict["lastElectricity"] = row.electricity
//                        break
//                    }
//                }
//
//                try response.setBody(json: ["success": true, "status": 200, "data": paymentDict])
//                response.completed()
//
//            } catch {
//                serverErrorHandler(request, response)
//                Log.error(message: "details : \(error)")
//            }
//        }
//    }
//
    // 退房
    open static func checkOut() -> RequestHandler {
        return {
            request, response in
            do {
                //id
                guard let room_id = UUID.init(uuidString: request.param(name: "room_id")!) else {
                    error(request, response, error: "room_id 参数不正确")
                    return
                }

                var room = Room()
                room.state = true
                room.updated_at = Date()
                
                let roomTable = db.table(Room.self)
                try roomTable.where(\Room.id == room_id).update(room, setKeys: \.state, \.updated_at)
                
                var tenant = Tenant()
                tenant.state = true
                tenant.updated_at = Date()
                
                let tenantTable = db.table(Tenant.self)
                try tenantTable.where(\Tenant.room_id == room_id).update(tenant, setKeys: \.state, \.updated_at)
                
                try response.setBody(json: ["success": true, "status": 200, "data": "退房成功"])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
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


