//
//  Room.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation

struct Room: Codable {
    
    let id: UUID
    let state: Bool                          //是否退房
    let room_no: String?                        //房间号
    let rent_money: Int?                          //租金
    let deposit: Int?                                   //押金
    let lease_term: Int?                         //租期
    let rent_date: String?               //收租日期
    let network: Int?                       //网络
    let trash_fee: Int?                             //垃圾费
    let water_max: Int?                     //水表阈值
    let electricity_max: Int?               //电表阈值
    let create_at: String            //创建时间
    let updated_at: String                //更新时间
    let payments:  [Payment]?
    let tenants: [Tenant]?

    public init(state: Bool, room_no: String?, rent_money: Int?, deposit: Int?, lease_term: Int?, rent_date: String?, network: Int?, trash_fee: Int?) {
        
        self.init(state: state, room_no: room_no, rent_money: rent_money, deposit: deposit, lease_term: lease_term, rent_date: rent_date, network: network, trash_fee: trash_fee, water_max: nil, electricity_max: nil)
    }
    
    public init(state: Bool, room_no: String?, rent_money: Int?, deposit: Int?, lease_term: Int?, rent_date: String?, network: Int?, trash_fee: Int?, water_max: Int?, electricity_max: Int?) {
        self.id = UUID()
        self.state = state
        self.room_no = room_no
        self.rent_money = rent_money
        self.deposit = deposit
        self.lease_term = lease_term
        self.rent_date = rent_date
        self.network = network
        self.trash_fee = trash_fee
        self.water_max = water_max
        self.electricity_max = electricity_max
        self.create_at = Date().iso8601()
        self.updated_at = Date().iso8601()
        self.payments = nil
        self.tenants = nil
    }
}

