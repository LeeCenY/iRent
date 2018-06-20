//
//  Payment.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation

struct Payment: Codable {
    
    let id: UUID
    let room_id: UUID                                 //房间id
    let state: Bool                                   //是否已经缴费
    let payee: String?                              //收款人
    let rent_date: String       //月份
    let money: Double?                        //总数
    let rent_money: Int?                       //租金
    let water: Int?                               //水表数
    let electricity: Int?                      //电表数
    let network: Int?                            //网络
    let trash_fee: Int?                       //垃圾费
    let image_url: String?                          //图片URL
    let arrears: Double?                        //欠费
    let remark: String?                     //备注
    let create_at: String  //创建时间
    let updated_at: String   //更新时间

    public init(room_id: UUID, state: Bool, payee: String?, rent_date: String, money: Double?, rent_money: Int?, water: Int?, electricity: Int?, network: Int?, trash_fee: Int?, image_url: String?, arrears: Double?, remark: String?) {
        self.id = UUID()
        self.room_id = room_id
        self.state = state
        self.payee = payee
        self.rent_date = rent_date
        self.money = money
        self.rent_money = rent_money
        self.water = water
        self.electricity = electricity
        self.network = network
        self.trash_fee = trash_fee
        self.image_url = image_url
        self.arrears = arrears
        self.remark = remark
        self.create_at = Date().iso8601()
        self.updated_at = Date().iso8601()
    }
}

