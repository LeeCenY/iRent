//
//  Payment.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation
import StORM
import MySQLStORM
import SwiftMoment

class Payment: MySQLStORM {
    
    var id: Int                         = 0
    var room_id: Int                    = 0                     //房间id
    var state: Int                      = 0                     //是否已经缴费
    var payee: String                   = ""                    //收款人
    var month: String                   = moment().format(DateFormat.month)                  //月份
    var money: Double                   = 0.00                    //总数
    var rent_money: Int                 = 0                     //租金
    var water: Int                      = 0                     //水表数
    var electricity: Int                = 0                     //电表数
    var network: Int                    = 0                     //网络
    var trash_fee: Int                  = 0                     //垃圾费
    var arrears: Double                 = 0.00                     //欠费
    var remark: String                  = ""                    //备注
    var create_at: Date                 = moment().date         //创建时间
    var updated_at: Date                = moment().date         //更新时间
    
    override open func table() -> String {
        return "Payment"
    }
    
    override func to(_ this: StORMRow) {
        id                  = Int(this.data["id"]                   as? Int32       ?? 0)
        room_id             = Int(this.data["room_id"]              as? Int32       ?? 0)
        state               = Int(this.data["state"]                as? Int32       ?? 0)
        payee               = this.data["payee"]                    as? String      ?? ""
        month               = this.data["month"]                    as? String      ?? moment().format(DateFormat.month)
        money               = this.data["money"]                    as? Double      ?? 0.00
        rent_money          = Int(this.data["rent_money"]           as? Int32       ?? 0)
        water               = Int(this.data["water"]                as? Int32       ?? 0)
        electricity         = Int(this.data["electricity"]          as? Int32       ?? 0)
        network             = Int(this.data["network"]              as? Int32       ?? 0)
        trash_fee           = Int(this.data["trash_fee"]            as? Int32       ?? 0)
        arrears             = this.data["arrears"]                  as? Double      ?? 0.00
        remark              = this.data["remark"]                   as? String      ?? ""
        create_at           = this.data["create_at"]                as? Date        ?? moment().date
        updated_at          = this.data["updated_at"]               as? Date        ?? moment().date
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
            "room_id":          self.room_id,
            "water":            self.water,
            "electricity":      self.electricity,
            "network":          self.network,
            "trash_fee":        self.trash_fee,
            "rent_money":       self.rent_money,
            "money":            self.money,
            "lastWater":        self.water,
            "lastElectricity":  self.electricity,
        ]
    }
    
}

