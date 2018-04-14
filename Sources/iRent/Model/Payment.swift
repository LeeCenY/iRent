//
//  Payment.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation
import PerfectCRUD
import PerfectMySQL

struct Payment: Codable {
    var id: UUID                        = UUID()
    var room_id: UUID                   = UUID()                     //房间id
    var state: Bool                     = false                     //是否已经缴费
    var payee: String                   = ""                    //收款人
    var rent_date: String               = Date().toDateString()    //月份
    var money: Double                   = 0.00                  //总数
    var rent_money: Int                 = 0                     //租金
    var water: Int                      = 0                     //水表数
    var electricity: Int                = 0                     //电表数
    var network: Int                    = 0                     //网络
    var trash_fee: Int                  = 0                     //垃圾费
    var arrears: Double                 = 0.00                     //欠费
    var remark: String                  = ""                    //备注
    var create_at: Date                = Date()    //创建时间
    var updated_at: Date               = Date()    //更新时间
}

