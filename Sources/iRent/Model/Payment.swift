//
//  Payment.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation
import StORM
import MySQLStORM

class Payment: MySQLStORM {
    
    var id: Int                         = 0
    var room_id: Int                    = 0                     //房间id
    var state: Int                      = 0                     //是否已经缴费
    var payee: String                   = ""                    //收款人
    var month: String                   = ""                    //月份
    var money: String                   = ""                    //总数
    var water: String                   = ""                    //水表数
    var electricity: String             = ""                    //电表数
    var network: Int                    = 0                     //网络
    var trash_fee: Int                  = 0                     //垃圾费
    var arrears: String                 = ""                    //欠费
    var remark: String                  = ""                    //备注
    var create_at: String               = Date().string()       //创建时间
    var updated_at: String              = Date().string()       //更新时间
    
    override open func table() -> String {
        return "Payment"
    }
    
    override func to(_ this: StORMRow) {
        id                  = Int(this.data["id"]                   as? Int32       ?? 0)
        room_id             = Int(this.data["room_id"]              as? Int32       ?? 0)
        state               = Int(this.data["state"]                as? Int32       ?? 0)
        payee               = this.data["payee"]                    as? String      ?? ""
        month               = this.data["month"]                    as? String      ?? ""
        money               = this.data["money"]                    as? String      ?? ""
        water               = this.data["water"]                    as? String      ?? ""
        electricity         = this.data["electricity"]              as? String      ?? ""
        network             = Int(this.data["trash_fee"]            as? Int32       ?? 0)
        trash_fee           = Int(this.data["trash_fee"]            as? Int32       ?? 0)
        arrears             = this.data["arrears"]                  as? String      ?? ""
        remark              = this.data["remark"]                   as? String      ?? ""
        create_at           = this.data["create_at"]                as? String      ?? Date().string()
        updated_at          = this.data["updated_at"]               as? String      ?? Date().string()
    }
    
    func rows() -> [Payment] {
        var rows = [Payment]()
        for i in 0..<self.results.rows.count {
            let row = Payment()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    
    //详情页面返回值
    func asDetailDict() -> [String: Any] {
        return [
            "id":               self.id,
            "water":            self.water,
            "electricity":      self.electricity,
            "network":          self.network,
            "trash_fee":        self.trash_fee,
            "create_at":        self.create_at,
            "updated_at":       self.updated_at,
        ]
    }
    
}

