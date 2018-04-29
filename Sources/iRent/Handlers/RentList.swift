
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectCRUD
import DateToolsSwift

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
                    limit = 20
                }
                
                var roomArray: [[String: Any]] = []
                
                if (listType == "all") {
                    
                    let roomTable = db.table(Room.self)
                    let query = try roomTable
                        .limit(limit, skip: offset)
                        .join(\.payments, on: \.id, equals: \.room_id)
                        .where(\Room.state == false)
                        .select().map{ $0 }
                    
                    for row in query {
                        var roomDict:[String: Any] = [String: Any]()
                        roomDict["id"] = row.id.uuidString
                        roomDict["state"] = row.state
                        roomDict["room_no"] = row.room_no
                        roomDict["rent_money"] = row.rent_money
                        roomDict["deposit"] = row.deposit
                        roomDict["lease_term"] = row.lease_term
                        roomDict["rent_date"] = row.rent_date
                        roomDict["network"] = row.network
                        roomDict["trash_fee"] = row.trash_fee
                        roomDict["create_at"] = row.create_at
                        roomDict["updated_at"] = row.updated_at
                        
                        guard let payments = row.payments else {
                            continue
                        }
                        
                    var paymentDict:[String: Any] = [String: Any]()
                    for (index, payment)  in payments.enumerated() {
                        
                        if (index == 0) {
                            paymentDict["water"] = payment.water
                            paymentDict["electricity"] = payment.electricity
                            paymentDict["last_Water"] = payment.water
                            paymentDict["lase_Electricity"] = payment.electricity
                            paymentDict["rent_date"] = payment.rent_date
                        }
                        
                        if (index == 1) {
                            paymentDict["last_Water"] = payment.water
                            paymentDict["lase_Electricity"] = payment.electricity
                        }
                        
                        paymentDict["id"] = payment.id.uuidString
                        paymentDict["room_id"] = payment.room_id.uuidString
                        paymentDict["state"] = payment.state
                        paymentDict["rent_money"] = payment.rent_money
                        paymentDict["network"] = payment.network
                        paymentDict["trash_fee"] = payment.trash_fee
                        paymentDict["create_at"] = payment.create_at
                        paymentDict["updated_at"] = payment.updated_at
                    }
                        
                    roomDict["payments"] = paymentDict
                    roomArray.append(roomDict as [String: Any])
                    }
                }else {
                    
                    var timeChunk = TimeChunk.init()
                    timeChunk.months = 1
                    
                    var startTimeChunk = TimeChunk.init()
                    startTimeChunk.months = 1
                    startTimeChunk.days = 5
                    
                    var endTimeChunk = TimeChunk.init()
                    endTimeChunk.months = 1
                    endTimeChunk.days = -5

                    let startDate = Date().subtract(startTimeChunk).toDateString()
                    let endDate = Date().subtract(endTimeChunk).toDateString()
                
                    
                    //查询快到期和未交
                    let paymentTable = db.table(Payment.self)
                    let query = try paymentTable
                        .where((\Payment.rent_date >= startDate && \Payment.rent_date <= endDate) || \Payment.state == false)
                        .select().map{ $0 }

                    for row in query {
                    
                        var paymentDict:[String: Any] = [String: Any]()
                        paymentDict["id"] = row.id.uuidString
                        paymentDict["room_id"] = row.room_id.uuidString
                        paymentDict["state"] = row.state
                        paymentDict["water"] = row.water
                        paymentDict["electricity"] = row.electricity
                        paymentDict["rent_date"] = row.rent_date
                        paymentDict["updated_at"] = row.updated_at
                        paymentDict["last_water"] = row.water
                        paymentDict["last_electricity"] = row.electricity
                        
                        let roomTable = db.table(Room.self)
                        let rowQuery = try roomTable
                            .where(\Room.id == row.room_id)
                            .select().map{ $0 }
                        
                        //查询房间信息
                        for row in rowQuery {
                            paymentDict["room_no"] = row.room_no
                            paymentDict["rent_money"] = row.rent_money
                            paymentDict["deposit"] = row.deposit
                            paymentDict["lease_term"] = row.lease_term
                            paymentDict["network"] = row.network
                            paymentDict["trash_fee"] = row.trash_fee
                        }

                    
                        let rent_date = row.rent_date.toDate()?.subtract(timeChunk).toDateString()
                        
                        //查询上个月信息
                        let lastQuery = try paymentTable
                            .where(\Payment.room_id == row.room_id && \Payment.rent_date == rent_date!)
                            .select().map{ $0 }
                        
                        for last in lastQuery {
                            paymentDict["last_water"] = last.water
                            paymentDict["last_electricity"] = last.electricity
                        }
                        roomArray.append(paymentDict)
                    }
                }
                try response.setBody(json: ["success": true, "status": 200, "data": roomArray] as [String: Any])
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
                        resError(request, response, error: "请填写请求参数")
                        return
                }
                //id
                guard let id = UUID.init(uuidString: (dict["id"] as? String)!) else {
                    resError(request, response, error: "id 请求参数不正确")
                    return
                }
                //收租时间
                guard let rentDate: String = dict["rent_date"] as? String, rentDate.toDate() != nil else {
                    resError(request, response, error: "收租时间 rentdate 请求参数不正确")
                    return
                }
                //总数
                guard let money: String = dict["money"] as? String, Double(money) != nil else {
                    resError(request, response, error: "总数 money 请求参数不正确")
                    return
                }
                //收款人
                guard let payee: String = dict["payee"] as? String else {
                    resError(request, response, error: "收款人 payee 请求参数不正确")
                    return
                }
                //账单状态
                guard let state: Bool = dict["state"] as? Bool else {
                    resError(request, response, error: "账单状态 state 请求参数不正确")
                    return
                }

                let payment = Payment.init(id: UUID(), room_id: UUID(), state: state, payee: payee, rent_date: rentDate, money: Double(money)!, rent_money: nil, water: nil, electricity: nil, network: nil, trash_fee: nil, arrears: nil, remark: nil, create_at: Date().iso8601(), updated_at: Date().iso8601())
                
                let paymentTable = db.table(Payment.self)
                
                let query = try paymentTable
                    .where(\Payment.room_id == id && \Payment.rent_date == rentDate && \Payment.state == true)
                    .count()
                if (query > 0) {
                    try response.setBody(json: ["success": true, "status": 200, "data": "已经到账"])
                    response.completed()
                    return
                }
            
                try paymentTable
                    .where(\Payment.room_id == id && \Payment.rent_date == rentDate)
                    .update(payment, setKeys: \.state, \.payee, \.money, \.updated_at)
                
                try response.setBody(json: ["success": true, "status": 200, "data": "收账"])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
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
                        resError(request, response, error: "room_id 参数不正确")
                        return
                    }
    
                    //收租时间
                    guard let rentdate = request.param(name: "rent_date") else {
                        resError(request, response, error: "收租时间 rentdate 请求参数不正确")
                        return
                    }

                    var lastTimeChunk = TimeChunk.init()
                    lastTimeChunk.months = 1
                    let lastDate = rentdate.toDate()?.subtract(lastTimeChunk).toDateString()

                    let paymentTable = db.table(Payment.self)
                    let query = try paymentTable
                        .where(\Payment.room_id == UUID.init(uuidString: room_id)! && \Payment.rent_date == rentdate)
                        .select().map{ $0 }
                    
                    var paymentDict:[String: Any] = [String: Any]()
                    for row in query {
            
                        paymentDict["id"] = row.id.uuidString
                        paymentDict["room_id"] = row.room_id.uuidString
                        paymentDict["state"] = row.state
                        paymentDict["water"] = row.water
                        paymentDict["electricity"] = row.electricity
                        paymentDict["rent_date"] = row.rent_date
                        paymentDict["network"] = row.network
                        paymentDict["trash_fee"] = row.trash_fee
                        paymentDict["updated_at"] = row.updated_at
                        paymentDict["last_water"] = row.water
                        paymentDict["last_electricity"] = row.electricity
                        
                        let lastQuery = try paymentTable
                            .where(\Payment.room_id == UUID.init(uuidString: room_id)! && \Payment.rent_date == lastDate!)
                            .select().map{ $0 }
                        
                        for last in lastQuery {
                            paymentDict["last_water"] = last.water
                            paymentDict["last_electricity"] = last.electricity
                        }
                    }

                    try response.setBody(json: ["success": true, "status": 200, "data": paymentDict])
                    response.completed()
                } catch {
                    serverErrorHandler(request, response)
                    Log.error(message: "details : \(error)")
                }
            }
        }
    
    // 退房
    open static func checkOut() -> RequestHandler {
        return {
            request, response in
            do {
                //id
                guard let room_id = UUID.init(uuidString: request.param(name: "room_id")!) else {
                    resError(request, response, error: "room_id 参数不正确")
                    return
                }
                
                let room = Room.init(id: UUID(), state: true, room_no: "", rent_money: 0, deposit: 0, lease_term: 0, rent_date: "", network: 0, trash_fee: 0, create_at: Date().iso8601(), updated_at: Date().iso8601(), payments: nil, tenants: nil)
                
                let tenant = Tenant.init(id: UUID(), room_id: UUID(), state: true, name: "", idcard: "", phone: "", create_at: Date().iso8601(), updated_at: Date().iso8601())
                
                let tenantTable = db.table(Tenant.self)
                let roomTable = db.table(Room.self)
                
                if try roomTable.where(\Room.id == room_id).count() == 0 {
                    resError(request, response, error: "room_id 不存在")
                }
                
                do {
                    try roomTable.where(\Room.id == room_id).update(room, setKeys: \.state, \.updated_at)
                    try tenantTable.where(\Tenant.room_id == room_id).update(tenant, setKeys: \.state, \.updated_at)
                } catch {
                    resError(request, response, error: "退房失败")
                }

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


