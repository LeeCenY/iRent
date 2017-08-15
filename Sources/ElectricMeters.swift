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
    
    var id				: Int       = 0
    var tenants_id		: Int       = 0
    var electricmeter_month   : String    = ""
    var electricmeter_number	: Int       = 0
    
    override open func table() -> String {
        return "users_meters"
    }
    
    override func to(_ this: StORMRow) {
        id                      = Int(this.data["id"]                       as? Int32       ?? 0)
        tenants_id              = Int(this.data["tenants_id"]               as? Int32       ?? 0)
        electricmeter_month     = this.data["electricmeter_month"]          as? String      ?? ""
        electricmeter_number	= Int(this.data["electricmeter_number"]     as? Int32       ?? 0)
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
