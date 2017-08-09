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

class Meters: MySQLStORM {
    
    var id				: Int       = 0
    var tenants_id		: Int       = 0
    var meter_month     : String    = ""
    var meter_number	: String    = ""
    
    override open func table() -> String {
        return "users_meter"
    }
    
    override func to(_ this: StORMRow) {
        id              = Int(this.data["id"]               as? UInt32      ?? 0)
        tenants_id		= Int(this.data["tenants_id"]       as? UInt32      ?? 0)
        meter_month     = this.data["meter_month"]          as? String      ?? ""
        meter_number	= this.data["meter_number"]         as? String		?? ""
        
    }
    
    func rows() -> [Meters] {
        var rows = [Meters]()
        for i in 0..<self.results.rows.count {
            let row = Meters()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }

}
