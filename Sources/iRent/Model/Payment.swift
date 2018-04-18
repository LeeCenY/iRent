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
    let id: UUID
    let room_id: UUID                                 //房间id
    let state: Bool?                                   //是否已经缴费
    let payee: String?                              //收款人
    let rent_date: String?       //月份
    let money: Double?                        //总数
    let rent_money: Int?                       //租金
    let water: Int?                               //水表数
    let electricity: Int?                      //电表数
    let network: Int?                            //网络
    let trash_fee: Int?                       //垃圾费
    let arrears: Double?                        //欠费
    let remark: String?                     //备注
    let create_at: Date  //创建时间
    let updated_at: Date   //更新时间
}

