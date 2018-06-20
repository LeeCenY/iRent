
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
                    
                    let roomTable = db().table(Room.self)
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
                
                    
                    //根据上月的时间来查询快到期和未交
                    let paymentTable = db().table(Payment.self)
                    //查询快到期
                    let query = try paymentTable
                        .order(by: \.rent_date)
                        .where(\Payment.rent_date >= startDate && \Payment.rent_date <= endDate)
                        .select()
                    
                    for row in query {
                        
                        var paymentDict:[String: Any] = [String: Any]()
                        
                        let roomTable = db().table(Room.self)
                        let rowQuery = try roomTable
                            .where(\Room.id == row.room_id)
                            .select().map{ $0 }
                        
                        //查询房间信息
                        for roomRow in rowQuery {
                            
                            if(roomRow.state == true) {
                                continue
                            }
                            
                            paymentDict["room_no"] = roomRow.room_no
                            paymentDict["rent_money"] = roomRow.rent_money
                            paymentDict["deposit"] = roomRow.deposit
                            paymentDict["lease_term"] = roomRow.lease_term
                            paymentDict["network"] = roomRow.network
                            paymentDict["trash_fee"] = roomRow.trash_fee

                            paymentDict["id"] = row.id.uuidString
                            paymentDict["room_id"] = row.room_id.uuidString
                            paymentDict["state"] = false
                            paymentDict["water"] = row.water
                            paymentDict["electricity"] = row.electricity
                            paymentDict["rent_date"] = Date.init(dateString: row.rent_date, .Date).add(timeChunk).toDateString()
                            paymentDict["updated_at"] = row.updated_at
                            paymentDict["last_water"] = row.water
                            paymentDict["last_electricity"] = row.electricity
                            paymentDict["is_rang"] = true

                            guard let rent_date = row.rent_date.toDate()?.add(timeChunk).toDateString() else {
                                resError(request, response, error: "rent_date 错误")
                                return
                            }

                            //查询本月信息
                            let lastQuery = try paymentTable
                                .where(\Payment.room_id == row.room_id && \Payment.rent_date == rent_date)
                                .select().map{ $0 }

                            for last in lastQuery {
                                paymentDict["id"] = last.id.uuidString
                                paymentDict["state"] = last.state
                                paymentDict["water"] = last.water
                                paymentDict["electricity"] = last.electricity
                                paymentDict["rent_date"] = last.rent_date
                                paymentDict["updated_at"] = last.updated_at
                            }
                            roomArray.append(paymentDict)
                        }
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
                //图片链接
                guard let imageURL: String = dict["image_url"] as? String else {
                    resError(request, response, error: "图片链接 image_url 请求参数不正确")
                    return
                }
                
                let roomTable = db().table(Room.self)
                let queryID = roomTable.where(\Room.id == id && \Room.state == false)

                guard try queryID.count() != 0 else {
                    resError(request, response, error: "房间 id 不存在")
                    return
                }

                let payment = Payment.init(room_id: UUID(), state: state, payee: payee, rent_date: rentDate, money: Double(money)!, rent_money: nil, water: nil, electricity: nil, network: nil, trash_fee: nil, image_url: imageURL, arrears: nil, remark: nil)
                
                let paymentTable = db().table(Payment.self)
                
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
                    .update(payment, setKeys: \.state, \.payee, \.money, \.image_url, \.updated_at)
                
                try response.setBody(json: ["success": true, "status": 200, "data": ["state": true]])
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
    
                    guard let room_id = UUID.init(uuidString: request.param(name: "room_id")!) else {
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

                    //收租时间
                    guard let lastDate = rentdate.toDate()?.subtract(lastTimeChunk).toDateString() else {
                        resError(request, response, error: "上月时间 lastDate 转换出错")
                        return
                    }

                    //查询本月
                    let paymentTable = db().table(Payment.self)
                    let query = try paymentTable
                        .where(\Payment.room_id == room_id && \Payment.rent_date == lastDate)
                        .select()
                    
                    var paymentDict:[String: Any] = [String: Any]()
                    for row in query {
            
                        paymentDict["id"] = row.id.uuidString
                        paymentDict["room_id"] = row.room_id.uuidString
                        paymentDict["state"] = false
                        paymentDict["water"] = row.water
                        paymentDict["electricity"] = row.electricity
                        paymentDict["rent_date"] = Date.init(dateString: row.rent_date, .Date).add(lastTimeChunk).toDateString()
                        paymentDict["network"] = row.network
                        paymentDict["last_water"] = row.water
                        paymentDict["last_electricity"] = row.electricity
                        

                        let roomTable = db().table(Room.self)
                        let roomQuery = try roomTable
                            .where(\Room.id == row.room_id)
                            .select()
                        
                        //查询房间信息
                        for room in roomQuery {
                            paymentDict["room_no"] = room.room_no
                            paymentDict["rent_money"] = room.rent_money
                            paymentDict["deposit"] = room.deposit
                            paymentDict["lease_term"] = room.lease_term
                            paymentDict["network"] = room.network
                            paymentDict["trash_fee"] = room.trash_fee
                        }

                        //查询上月
                        let lastQuery = try paymentTable
                            .where(\Payment.room_id == room_id && \Payment.rent_date == rentdate)
                            .select()
                        
                        for last in lastQuery {
                            paymentDict["water"] = last.water
                            paymentDict["electricity"] = last.electricity
                            paymentDict["state"] = last.state
                            paymentDict["rent_date"] = last.rent_date
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
                //TODO 还需要根据多种情况操作退房
                let room = Room.init(state: true, room_no: "", rent_money: 0, deposit: 0, lease_term: 0, rent_date: "", network: 0, trash_fee: 0)
                
                let tenant = Tenant.init(room_id: UUID(), state: true, name: "", idcard: "", phone: "")
                
                let tenantTable = db().table(Tenant.self)
                let roomTable = db().table(Room.self)
                
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


