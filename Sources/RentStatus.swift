//
//  RentalStatus.swift
//  iRentPackageDescription
//
//  Created by nil on 2017/12/3.
//

import Foundation
import StORM
import MySQLStORM

class RentStatus: MySQLStORM {
    
    var id: Int                     = 0
    var roomnumber_id: Int          = 0
    var rent_month: String          = ""
    var rent_received: String       = ""
    var leased_time: Int            = 0
    var create_time: String         = Date().string()       //创建时间
    var update_time: String         = Date().string()       //更新时间
    
    override open func table() -> String {
        return "RentStatus"
    }
    
    override func to(_ this: StORMRow) {
        id                  = Int(this.data["id"]                   as? Int32       ?? 0)
        roomnumber_id       = Int(this.data["roomnumber_id"]        as? Int32       ?? 0)
        rent_month          = this.data["rent_month"]               as? String      ?? ""
        rent_received       = this.data["rent_received"]            as? String      ?? ""
        leased_time         = this.data["leased_time"]              as? Int         ?? 0
        create_time         = this.data["create_time"]              as? String      ?? Date().string()
        update_time         = this.data["update_time"]              as? String      ?? Date().string()
    }
    
    func rows() -> [RentStatus] {
        var rows = [RentStatus]()
        for i in 0..<self.results.rows.count {
            let row = RentStatus()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}

