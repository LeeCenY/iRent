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
    var roomnumber_id: Int              = 0                     //房间号id
    var fullname: String                = ""                    //姓名
    var idcardnumber: String            = ""                    //身份证号码
    var phonenumber: String             = ""                    //手机号
    var create_time: String             = Date().string()       //创建时间
    var update_time: String             = Date().string()       //更新时间

    override func table() -> String {
        return "Tenants"
    }
    
    override func to(_ this: StORMRow) {
        id              = Int(this.data["id"]           as? Int32       ?? 0)
        roomnumber_id   = this.data["roomnumber"]       as? Int         ?? 0
        fullname        = this.data["fullname"]         as? String      ?? ""
        idcardnumber    = this.data["idcardnumber"]     as? String      ?? ""
        phonenumber     = this.data["phonenumber"]      as? String      ?? ""
        create_time     = this.data["create_time"]      as? String      ?? Date().string()
        update_time     = this.data["update_time"]      as? String      ?? Date().string()
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

