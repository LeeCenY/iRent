
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectCRUD

/// 收租信息列表
public class RentList: BaseHandler {
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
                
                let roomTable = db.table(Room.self)
                let query = try roomTable
                    .limit(limit, skip: offset)
                    .join(\.payment, on: \.id, equals: \.room_id)
                    .select()

                var roomArray: [[String: Any]] = []

                var ssss = Date()
                
                for row in query {
                    print("\(row.updated_at)")
                    print("\(row.create_at)")
                    print("\(row.id)")
                    ssss = row.updated_at
                    roomArray.append(row.asDetailDict() as [String: Any])
                }
                
                let jsonDict = ["success": true, "status": 200, "data": ssss] as [String : Any]

                try response.setBody(json: jsonDict)
                response.setHeader(.contentType, value: "application/json")
                response.completed()
                return
            } catch {
                serverErrorHandler(request, response)
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

                
                let payment = Payment.init(id: UUID(), room_id: UUID(), state: state, payee: "", rent_date: "", money: 0, rent_money: 0, water: 0, electricity: 0, network: 30, trash_fee: 50, arrears: 0, remark: "", create_at: Date(), updated_at: Date())
//                payment.state = state
//                payment.updated_at = Date()
                
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
//                guard let rentdate = request.param(name: "rentdate") else {
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

               let room = Room.init(id: UUID(), state: true, room_no: "", rent_money: 0, deposit: 0, lease_term: 0, rent_date: "", network: 0, trash_fee: 0, create_at: Date(), updated_at: Date(), payment: nil, tenant: nil)
                
//                let room = Room.init(id: UUID(), state: true, room_no: "", rent_money: 0, deposit: 0, lease_term: 0, rent_date: "", network: 0, trash_fee: 0, create_at: Date(), updated_at: Date())
//                room.state = true
//                room.updated_at = Date()
                
                let roomTable = db.table(Room.self)
                try roomTable.where(\Room.id == room_id).update(room, setKeys: \.state, \.updated_at)
                
                let tenant = Tenant.init(id: UUID(), room_id: UUID(), state: true, name: "", idcard: "", phone: "", create_at: Date(), updated_at: Date())
//                tenant.state = true
//                tenant.updated_at = Date()
                
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


