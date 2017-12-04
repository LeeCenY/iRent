//
//  RoomNo.swift
//  iRentPackageDescription
//
//  Created by nil on 2017/12/3.
//

import Foundation
import StORM
import MySQLStORM

class RoomNumber: MySQLStORM {
    
    var id: Int                         = 0
    var uuid: String                    = UUID().uuidString
    var roomnumber: String              = ""                    //房间号
    var rent: String                    = ""                    //租金
    var deposit: String                 = ""                    //押金
    var leaseterm: String               = "6"                   //租期
    var renttime: Int                   = 1                     //收租日期
    var internetfee: Int                = 0                     //网络
    var trashfee: Int                   = 0                     //垃圾费
    var remark: String                  = ""                    //备注
    var create_time: String             = Date().string()       //创建时间
    var update_time: String             = Date().string()       //更新时间
    
    var _tenants                        = [Tenants]()           //住户
    var _electricmeters                 = [ElectricMeters]()    //电表
    var _watermeters                    = [WaterMeters]()       //水表
    var _rentStatus                     = [RentStatus]()        //收租状态
    
    override func table() -> String {
        return "RoomNumber"
    }
    
    override func to(_ this: StORMRow) {
        id              = Int(this.data["id"]           as? Int32       ?? 0)
        uuid            = this.data["uuid"]             as? String      ?? UUID.init().uuidString
        roomnumber      = this.data["roomnumber"]       as? String      ?? ""
        rent            = this.data["rent"]             as? String      ?? ""
        deposit         = this.data["deposit"]          as? String      ?? ""
        leaseterm       = this.data["leaseterm"]        as? String      ?? "6"
        renttime        = Int(this.data["renttime"]     as? Int32       ?? 1)
        internetfee     = Int(this.data["internetfee"]  as? Int32       ?? 0)
        trashfee        = Int(this.data["trashfee"]     as? Int32       ?? 0)
        remark          = this.data["remark"]           as? String      ?? ""
        create_time     = this.data["create_time"]      as? String      ?? Date().string()
        update_time     = this.data["update_time"]      as? String      ?? Date().string()
        _tenants        = getTenants()
        _electricmeters = getElectricMeters()
        _watermeters    = getWatermeters()
        _rentStatus     = getRentStatus()
    }
    
    func rows() -> [RoomNumber] {
        var rows = [RoomNumber]()
        for i in 0..<self.results.rows.count {
            let row = RoomNumber()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    public func getTenants() -> [Tenants] {
        let tenants = Tenants()
        do {
            //根据 id 值来查询到水表数据库中 tenants_id 的数据
            try tenants.select(whereclause: "roomnumber_id = ?", params: [id], orderby: ["fullname DESC"])
        } catch {
            print("Tenants get error: \(error)")
        }
        return tenants.rows()
    }
    
    
    public func getElectricMeters() -> [ElectricMeters] {
        let electricMeters = ElectricMeters()
        do {
            //根据 id 值来查询到水表数据库中 tenants_id 的数据
            try electricMeters.select(whereclause: "roomnumber_id = ?", params: [id], orderby: ["electricmeter_month DESC"])
        } catch {
            print("electricmeters get error: \(error)")
        }
        return electricMeters.rows()
    }
    
    public func getWatermeters() -> [WaterMeters] {
        let watermeters = WaterMeters()
        do {
            try watermeters.select(whereclause: "roomnumber_id = ?", params: [id], orderby: ["watermeter_month DESC"])
        } catch {
            print("watermeters get error: \(error)")
        }
        return watermeters.rows()
    }
    
    public func getRentStatus() -> [RentStatus] {
        let rentStatus = RentStatus()
        do {
            try rentStatus.select(whereclause: "roomnumber_id = ?", params: [id], orderby: ["rent_month DESC"])
        } catch {
            print("rentStatus get error: \(error)")
        }
        return rentStatus.rows()
    }
    
    //首页页面返回值
    func asHomeDict() -> [String: Any] {

        var rentStatusArray = [[String: Any]]()
        _rentStatus.forEach { rentStatus in
            var dict = [String: Any]()
            dict["month"] = rentStatus.rent_month
            dict["number"] = rentStatus.rent_number
            rentStatusArray.append(dict)
        }
        
        return [
            "id":               self.id,
            "uuid":             self.uuid,
            "roomnumber":       self.roomnumber,
            "leaseterm":        self.leaseterm,
            "rent":             self.rent,
            "deposit":          self.deposit,
            "renttime":         self.renttime,
            "internetfee":      self.internetfee,
            "trashfee":         self.trashfee,
            "registertime":     self.create_time,
            "updatetime":       self.update_time,
            "rentstatus":       rentStatusArray,
        ]
    }
    
    //详情页面返回值
    func asDetailDict() -> [String: Any] {
        
        var tenantsArray = [[String: Any]]()
        _tenants.forEach { tenants in
            var dict = [String: Any]()
            dict["fullname"] = tenants.fullname
            dict["idcardnumber"] = tenants.idcardnumber
            dict["phonenumber"] = tenants.phonenumber
            tenantsArray.append(dict)
        }

        var electricmetersArray = [[String: Any]]()
        _electricmeters.forEach { electricmeters in
            var dict = [String: Any]()
            dict["month"] = electricmeters.electricmeter_month
            dict["number"] = electricmeters.electricmeter_number
            electricmetersArray.append(dict)
        }
        
        var watermetersArray = [[String: Any]]()
        _watermeters.forEach { watermeters in
            var dict = [String: Any]()
            dict["month"] = watermeters.watermeter_month
            dict["number"] = watermeters.watermeter_number
            watermetersArray.append(dict)
        }
        
        var rentStatusArray = [[String: Any]]()
        _rentStatus.forEach { rentStatus in
            var dict = [String: Any]()
            dict["month"] = rentStatus.rent_month
            dict["number"] = rentStatus.rent_number
            rentStatusArray.append(dict)
        }
        
        return [
            "id":               self.id,
            "uuid":             self.uuid,
            "roomnumber":       self.roomnumber,
            "leaseterm":        self.leaseterm,
            "rent":             self.rent,
            "deposit":          self.deposit,
            "renttime":         self.renttime,
            "internetfee":      self.internetfee,
            "trashfee":         self.trashfee,
            "registertime":     self.create_time,
            "updatetime":       self.update_time,
            "tenants":          tenantsArray,
            "meter":            electricmetersArray,
            "watermeter":       watermetersArray,
            "rentstatus":       rentStatusArray,
        ]
    }

}
