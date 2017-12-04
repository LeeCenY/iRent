//
//  Meters.swift
//  iRent
//
//  Created by TTLGZMAC6 on 2017/8/7.
//
//

import Foundation
import StORM
import MySQLStORM

class ElectricMeters: MySQLStORM {
    
    var id: Int                         = 0
    var roomnumber_id: Int              = 0
    var electricmeter_month: String     = ""
    var electricmeter_number: String    = ""
    var create_time: String             = Date().string()       //创建时间
    var update_time: String             = Date().string()       //更新时间
    
    override open func table() -> String {
        return "ElectricMeters"
    }
    
    override func to(_ this: StORMRow) {
        id                      = Int(this.data["id"]                       as? Int32       ?? 0)
        roomnumber_id           = Int(this.data["roomnumber_id"]            as? Int32       ?? 0)
        electricmeter_month     = this.data["electricmeter_month"]          as? String      ?? ""
        electricmeter_number	= this.data["electricmeter_number"]         as? String      ?? ""
        create_time             = this.data["create_time"]                  as? String      ?? Date().string()
        update_time             = this.data["update_time"]                  as? String      ?? Date().string()
    }
    
    func rows() -> [ElectricMeters] {
        var rows = [ElectricMeters]()
        for i in 0..<self.results.rows.count {
            let row = ElectricMeters()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }

}
