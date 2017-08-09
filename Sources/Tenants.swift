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
    var internet: Bool                  = false                 //网络
    var trashfee: Bool                  = false                 //垃圾费
    var registertime: String            = "\(Date())"           //登记时间
    var updatetime: String              = "\(Date())"           //更新时间
    var _meters                         = [Meters]()            //电表
    var _watermeters                     = [Watermeters]()      //水表
    
    
    override func table() -> String {
        return "user"
    }
    
    override func to(_ this: StORMRow) {
        id              = Int(this.data["id"]           as? UInt32                      ?? 0)
        uuid            = this.data["uuid"]             as? String                      ?? UUID.init().uuidString
        idcardnumber    = this.data["idcardnumber"]     as? String                      ?? ""
        phonenumber     = this.data["phonenumber"]      as? String                      ?? ""
        roomnumber      = this.data["roomnumber"]       as? String                      ?? ""
        leaseterm       = this.data["leaseterm"]        as? String                      ?? "6"
        rent            = this.data["rent"]             as? String                      ?? ""
        deposit         = this.data["deposit"]          as? String                      ?? ""
        renttime        = this.data["renttime"]         as? Int                         ?? 1
        internet        = this.data["internet"]         as? Bool                        ?? false
        trashfee        = this.data["trashfee"]         as? Bool                        ?? false
        registertime    = this.data["registertime"]     as? String                      ?? "\(Date())"
        updatetime      = this.data["updatetime"]       as? String                      ?? "\(Date())"
        _meters         = getMeters()
        _watermeters    = getWatermeter()
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
    
    public func getMeters() -> [Meters] {
        let meters = Meters()
        do {
            try meters.select(whereclause: "tenants_id = ?", params: [id], orderby: ["id"])
        } catch {
            print("meters get error: \(error)")
        }
        return meters.rows()
    }
    
    public func getWatermeter() -> [Watermeters] {
        let watermeters = Watermeters()
        do {
            try watermeters.select(whereclause: "tenants_id = ?", params: [id], orderby: ["id"])
        } catch {
            print("watermeters get error: \(error)")
        }
        return watermeters.rows()
    }
    
    func asDict() -> [String: Any] {
        
        var metersArray = [[String: Any]]()
        _meters.forEach { meters in
            var dict = [String: Any]()
//            dict["tenants_id"] = meters.tenants_id
            dict[meters.meter_month] = meters.meter_number
            metersArray.append(dict);
        }
        
        var watermeterArray = [[String: Any]]()
        _watermeters.forEach { watermeter in
            var dict = [String: Any]()
//            dict["tenants_id"]                  = watermeter.tenants_id
            dict[watermeter.watermeter_month]   = watermeter.watermeter_number
            watermeterArray.append(dict);
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
            "meter":            metersArray,
            "watermeter":  watermeterArray,
        ]
    }
}

