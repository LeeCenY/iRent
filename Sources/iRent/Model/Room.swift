//
//  Room.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation
import StORM
import MySQLStORM

class Room: MySQLStORM {
    
    var id: Int                         = 0
    var uuid: String                    = UUID().uuidString
    var state: Int                      = 0                     //是否退房
    var room_no: String                 = ""                    //房间号
    var rent_money: String              = ""                    //租金
    var deposit: String                 = ""                    //押金
    var lease_term: String              = ""                    //租期
    var rent_date: Int                  = 1                     //收租日期
    var network: Int                    = 0                     //网络
    var trash_fee: Int                  = 0                     //垃圾费
    var create_at: String               = Date().string()       //创建时间
    var updated_at: String              = Date().string()       //更新时间
    
    var tenant                          = [Tenant]()           //租户
    var payment                         = [Payment]()           //缴费
    
    override func table() -> String {
        return "Room"
    }
    
    override func to(_ this: StORMRow) {
        id              = Int(this.data["id"]           as? Int32       ?? 0)
        uuid            = this.data["uuid"]             as? String      ?? UUID.init().uuidString
        state           = Int(this.data["state"]        as? Int32       ?? 0)
        room_no         = this.data["room_no"]          as? String      ?? ""
        rent_money      = this.data["rent_money"]       as? String      ?? ""
        deposit         = this.data["deposit"]          as? String      ?? ""
        lease_term      = this.data["lease_term"]       as? String      ?? ""
        rent_date       = Int(this.data["rent_date"]    as? Int32       ?? 1)
        network         = Int(this.data["trash_fee"]    as? Int32       ?? 0)
        trash_fee       = Int(this.data["trash_fee"]    as? Int32       ?? 0)
        create_at       = this.data["create_at"]        as? String      ?? Date().string()
        updated_at      = this.data["updated_at"]       as? String      ?? Date().string()
        
        self.tenant          = getTenant()
        self.payment         = getPayment()
    }
    
    func rows() -> [Room] {
        var rows = [Room]()
        for i in 0..<self.results.rows.count {
            let row = Room()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    public func getTenant() -> [Tenant] {
        let tenant = Tenant()
        do {
            //根据 room_id 值来查询到租户 tenants 的数据
            try tenant.select(whereclause: "room_id = ?", params: [id], orderby: ["name DESC"])
        } catch {
            print("Tenant get error: \(error)")
        }
        return tenant.rows()
    }

    public func getPayment() -> [Payment] {
        let payment = Payment()
        do {
            //根据 id 值来查询到水表数据库中 tenants_id 的数据
            try payment.select(whereclause: "room_id = ?", params: [id], orderby: ["month DESC"])
        } catch {
            print("electricmeters get error: \(error)")
        }
        return payment.rows()
    }

    
    //首页页面返回值
    func asHomeDict() -> [String: Any] {

        var paymentArray = [[String: Any]]()
        self.payment.forEach { payment in
            var dict = [String: Any]()
            dict["month"] = payment.month
            dict["water"] = payment.water
            dict["electricity"] = payment.electricity
            paymentArray.append(dict)
        }
        
        
        return [
            "id":               self.id,
            "uuid":             self.uuid,
            "room_no":          self.room_no,
            "lease_term":       self.lease_term,
            "rent_money":       self.rent_money,
            "deposit":          self.deposit,
            "rent_date":        self.rent_date,
            "network":          self.network,
            "trash_fee":        self.trash_fee,
            "create_at":        self.create_at,
            "updated_at":       self.updated_at,
            "payment":          paymentArray.first as Any,
        ]
    }
    
    //详情页面返回值
    func asDetailDict() -> [String: Any] {
        
        var tenantArray = [[String: Any]]()
        self.tenant.forEach { tenant in
            var dict = [String: Any]()
            dict["name"] = tenant.name
            dict["idcard"] = tenant.idcard
            dict["phone"] = tenant.phone
            tenantArray.append(dict)
        }
        
        var paymentArray = [[String: Any]]()
        self.payment.forEach { payment in
            var dict = [String: Any]()
            dict["month"] = payment.month
            dict["water"] = payment.water
            dict["electricity"] = payment.electricity
            paymentArray.append(dict)
        }
        
        return [
            "id":               self.id,
            "uuid":             self.uuid,
            "room_no":          self.room_no,
            "lease_term":       self.lease_term,
            "rent_money":       self.rent_money,
            "deposit":          self.deposit,
            "rent_date":        self.rent_date,
            "network":          self.network,
            "trash_fee":        self.trash_fee,
            "create_at":        self.create_at,
            "updated_at":       self.updated_at,
            "tenant":           tenantArray.first  as Any,
            "payment":          paymentArray.first as Any,
        ]
    }
    
}
