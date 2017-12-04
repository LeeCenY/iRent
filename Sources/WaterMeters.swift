//
//  Watermeter.swift
//  iRent
//
//  Created by TTLGZMAC6 on 2017/8/9.
//
//

import Foundation
import StORM
import MySQLStORM

class WaterMeters: MySQLStORM {
    
    var id: Int                         = 0
    var roomnumber_id: Int              = 0
    var watermeter_month: String        = ""
    var watermeter_number: String       = ""
    var create_time: String             = Date().string()       //创建时间
    var update_time: String             = Date().string()       //更新时间
    
    override open func table() -> String {
        return "WaterMeters"
    }
    
    override func to(_ this: StORMRow) {
        id                  = Int(this.data["id"]                   as? Int32       ?? 0)
        roomnumber_id       = Int(this.data["roomnumber_id"]        as? Int32       ?? 0)
        watermeter_month    = this.data["watermeter_month"]         as? String      ?? ""
        watermeter_number	= this.data["watermeter_number"]        as? String      ?? ""
        create_time         = this.data["create_time"]              as? String      ?? Date().string()
        update_time         = this.data["update_time"]              as? String      ?? Date().string()
    }
    
    func rows() -> [WaterMeters] {
        var rows = [WaterMeters]()
        for i in 0..<self.results.rows.count {
            let row = WaterMeters()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
