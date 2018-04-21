
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectCRUD

/// 登记信息
public class Registration: BaseHandler  {
    /// 登记信息
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    static func tenant() -> RequestHandler {
        return {
            request, response in
            do {
                guard
                    let json:           String              = request.postBodyString,
                    let dict:           [String: Any]       = try json.jsonDecode()             as? [String: Any]
                    else {
                        resError(request, response, error: "请填写请求参数")
                        return
                }

                //姓名
                let name = dict["name"] as? String ?? ""
                //身份证
                let idcard = dict["idcard"] as? String ?? ""
                //网费
                let network = dict["network"] as? Int ?? 0
                //垃圾费
                let trashfee = dict["trashfee"] as? Int ?? 0

                //手机号
                guard let phone: String = dict["phone"] as? String, phone.count == 11 else {
                    resError(request, response, error: "手机号码 phone 请求参数不正确")
                    return
                }

                //房间号
                guard let roomno: String = dict["roomno"]  as? String else {
                    resError(request, response, error: "房间号 roomno 请求参数不正确")
                    return
                }
                //租期
                guard let leaseterm: Int = dict["leaseterm"] as? Int else {
                    resError(request, response, error: "租期 leaseterm 请求参数不正确")
                    return
                }
                //收租时间
                guard let rentdate: String = dict["rentdate"] as? String else {
                    resError(request, response, error: "收租时间 rentdate 请求参数不正确")
                    return
                }
                //租金
                guard  let rentmeony: Int = dict["rentmeony"] as? Int  else {
                    resError(request, response, error: "租金 rentmeony 请求参数不正确")
                    return
                }
                //押金
                guard   let deposit: Int = dict["deposit"] as? Int else {
                    resError(request, response, error: "押金 deposit 请求参数不正确")
                    return
                }

                //水表
                guard let water: Int = dict["water"] as? Int else {
                    resError(request, response, error: "水表 water 请求参数不正确")
                    return
                }
                //电表
                guard let electricity: Int = dict["electricity"] as? Int else {
                    resError(request, response, error: "电表 electricity 请求参数不正确")
                    return
                }

                let roomTable = db.table(Room.self)
                let tenantTable = db.table(Tenant.self)
                let paymentTable = db.table(Payment.self)

                let query = try roomTable
                    .where(\Room.room_no == roomno && \Room.state == false)
                    .select()
                for row in query {
                    try response.setBody(json: ["success": true, "status": 200, "data": "\(String(describing: row.room_no)) 房间号已存在"])
                    response.completed()
                    return
                }
                
                let room = Room.init(id: UUID.init(), state: false, room_no: roomno, rent_money: rentmeony, deposit: deposit, lease_term: leaseterm, rent_date: rentdate, network: network, trash_fee: trashfee, create_at: Date().iso8601(), updated_at: Date().iso8601(), payments: nil, tenants: nil)

                let tenant = Tenant.init(id: UUID.init(), room_id: room.id, state: false, name: name, idcard: idcard, phone: phone, create_at: Date().iso8601(), updated_at: Date().iso8601())

                let payment = Payment.init(id: UUID.init(), room_id: room.id, state: false, payee: "", rent_date: rentdate, money: 0, rent_money: rentmeony, water: water, electricity: electricity, network: network, trash_fee: trashfee, arrears: 0, remark: "", create_at: Date().iso8601(), updated_at: Date().iso8601())

                try roomTable.insert(room)
                try tenantTable.insert(tenant)
                try paymentTable.insert(payment)
                
                try response.setBody(json: ["success": true, "status": 200, "data": "登记信息成功"])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "registration : \(error)")
            }
        }
    }

}
