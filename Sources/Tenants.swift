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
    var uuid: String                    = UUID().uuidString
    var idcardnumber: String            = ""                    //身份证号码
    var phonenumber: String             = ""                    //手机号
    var roomnumber: String              = ""                    //房间号
    var leaseterm: String               = "6"                   //租期
    var rent: String                    = ""                    //租金
    var deposit: String                 = ""                    //押金
    var renttime: Int                   = 1                     //收租日期
    var internet: Int                   = 0                     //网络
    var trashfee: Int                   = 0                     //垃圾费
    var registertime: String            = Date().string()       //登记时间
    var updatetime: String              = Date().string()       //更新时间
    var _electricmeters                 = [ElectricMeters]()    //电表
    var _watermeters                    = [WaterMeters]()       //水表

    override func table() -> String {
        return "user"
    }
    
    override func to(_ this: StORMRow) {
        id              = Int(this.data["id"]           as? Int32                       ?? 0)
        uuid            = this.data["uuid"]             as? String                      ?? UUID.init().uuidString
        idcardnumber    = this.data["idcardnumber"]     as? String                      ?? ""
        phonenumber     = this.data["phonenumber"]      as? String                      ?? ""
        roomnumber      = this.data["roomnumber"]       as? String                      ?? ""
        leaseterm       = this.data["leaseterm"]        as? String                      ?? "6"
        rent            = this.data["rent"]             as? String                      ?? ""
        deposit         = this.data["deposit"]          as? String                      ?? ""
        renttime        = this.data["renttime"]         as? Int                         ?? 1
        internet        = this.data["internet"]         as? Int                         ?? 0
        trashfee        = this.data["trashfee"]         as? Int                         ?? 0
        registertime    = this.data["registertime"]     as? String                      ?? "\(Date())"
        updatetime      = this.data["updatetime"]       as? String                      ?? "\(Date())"
        _electricmeters = getElectricMeters()
        _watermeters    = getWatermeters()
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
    
    public func getElectricMeters() -> [ElectricMeters] {
        let ammeters = ElectricMeters()
        do {
            //根据 id 值来查询到水表数据库中 tenants_id 的数据
            try ammeters.select(whereclause: "tenants_id = ?", params: [id], orderby: ["electricmeter_month DESC"])
        } catch {
            print("electricmeters get error: \(error)")
        }
        return ammeters.rows()
    }
    
    public func getWatermeters() -> [WaterMeters] {
        let watermeters = WaterMeters()
        do {
            try watermeters.select(whereclause: "tenants_id = ?", params: [id], orderby: ["watermeter_month DESC"])
        } catch {
            print("watermeters get error: \(error)")
        }
        return watermeters.rows()
    }
    
    func asDict() -> [String: Any] {
        
        var electricmetersArray = [[String: Any]]()
        _electricmeters.forEach { electricmeters in
            var dict = [String: Any]()
            dict[electricmeters.electricmeter_month] = electricmeters.electricmeter_number
            electricmetersArray.append(dict);
        }
        
        var watermetersArray = [[String: Any]]()
        _watermeters.forEach { watermeters in
            var dict = [String: Any]()
            dict[watermeters.watermeter_month] = watermeters.watermeter_number
            watermetersArray.append(dict);
        }
        
        return [
            "id":               self.id,
            "uuid":             self.uuid,
            "idcardnumber":     self.idcardnumber,
            "phonenumber":      self.phonenumber,
            "roomnumber":       self.roomnumber,
            "leaseterm":        self.leaseterm,
            "rent":             self.rent,
            "deposit":          self.deposit,
            "renttime":         self.renttime,
            "internet":         self.internet,
            "trashfee":         self.trashfee,
            "registertime":     self.registertime,
            "updatetime":       self.updatetime,
            "meter":            electricmetersArray,
            "watermeter":       watermetersArray,
        ]
    }
}

