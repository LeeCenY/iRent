//
//  Tenants.swift
//  iRent
//
//  Created by TTLGZMAC6 on 2017/7/13.
//
//

import Foundation
import StORM
import MongoDBStORM

class Tenants: MongoDBStORM {
    
    var id: String = ""
    var mobilePhoneNo: String = ""
    var idNumber: String = ""
    var roomNumber: String = ""
    var registrationTime: Double = Date().timeIntervalSince1970
    var rentDate: String = ""
    var garbageFee: Bool = false
    var internetFee: Bool = false
    var rent: Int = 0
    var deposit: Int = 0
    var electricity = [Dictionary<String, String>()]
    var water = [Dictionary<String, String>()]
    
    
    override init() {
        super.init()
        _collection = "tenants"
    }
    
    override func to(_ this: StORMRow) {
        id = this.data["_id"] as? String ?? ""
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
    
    
}
