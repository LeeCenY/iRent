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

class Watermeters: MySQLStORM {
    
    var id                  : Int       = 0
    var tenants_id          : Int       = 0
    var watermeter_month    : String    = ""
    var watermeter_number	: String    = ""
    
    override open func table() -> String {
        return "users_watermeter"
    }
    
    override func to(_ this: StORMRow) {
        id                  = Int(this.data["id"]               as? UInt32      ?? 0)
        tenants_id          = Int(this.data["tenants_id"]       as? UInt32      ?? 0)
        watermeter_month    = this.data["watermeter_month"]     as? String      ?? ""
        watermeter_number	= this.data["watermeter_number"]    as? String		?? ""
    }
    
    func rows() -> [Watermeters] {
        var rows = [Watermeters]()
        for i in 0..<self.results.rows.count {
            let row = Watermeters()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}
