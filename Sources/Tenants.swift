//
//  Tenants.swift
//  iRent
//
//  Created by TTLGZMAC6 on 2017/7/13.
//
//

import Foundation
import StORM
import MySQLStORM

class Tenants: MySQLStORM {
    
    var id: Int                         = 0
    var idcardnumber: String            = ""            //身份证号码
    var phonenumber: String             = ""            //手机号
    var roomnumber: String              = ""            //房间号
    var leaseterm: Int                  = 0             //租期
    var rent: Int                       = 0             //租金
    var deposit: Int                    = 0             //押金
    var renttime: Int                   = 1             //收租日期
    var internet: Bool                  = false         //网络
    var trashfee: Bool                  = false         //垃圾费
    var meter: [[String: String]]       = [["":""]]     //电表
    var watermeter: [[String: String]]  = [["":""]]     //水表
    var registertime: String            = "\(Date())"   //登记时间
    var updatetime: String              = "\(Date())"   //更新时间
    
    override func table() -> String {
        return "user"
    }

    override func to(_ this: StORMRow) {
        id              = this.data["id"]               as? Int                 ?? 0
        idcardnumber    = this.data["idcardnumber"]     as? String              ?? ""
        phonenumber     = this.data["phonenumber"]      as? String              ?? ""
        roomnumber      = this.data["roomnumber"]       as? String              ?? ""
        leaseterm       = this.data["leaseterm"]        as? Int                 ?? 0
        rent            = this.data["rent"]             as? Int                 ?? 0
        deposit         = this.data["deposit"]          as? Int                 ?? 0
        renttime        = this.data["renttime"]         as? Int                 ?? 1
        internet        = this.data["internet"]         as? Bool                ?? false
        trashfee        = this.data["trashfee"]         as? Bool                ?? false
        meter           = this.data["meter"]            as? [[String : String]] ?? [["":""]]
        watermeter      = this.data["watermeter"]       as? [[String : String]] ?? [["":""]]
        registertime    = this.data["registertime"]     as? String              ?? "\(Date())"
        updatetime      = this.data["renttime"]         as? String              ?? "\(Date())"
    }
    
    func rows() -> [Tenants] {
        var rows = [Tenants]()
        for i in 0..<self.results.rows.count {
            let row = Tenants()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    func asDictionary() -> [NSString: Any] {
        return [
            "id":               self.id,
            "idcardnumber":     self.idcardnumber,
            "phonenumber":      self.phonenumber,
            "roomnumber":       self.roomnumber,
            "leaseterm":        self.leaseterm,
            "rent":             self.rent,
            "deposit":          self.deposit,
            "renttime":         self.deposit,
            "renttime":         self.renttime,
            "internet":         self.internet,
            "trashfee":         self.trashfee,
            "meter":            self.meter,
            "watermeter":       self.watermeter,
            "registertime":     self.registertime,
        ]
    }
}
