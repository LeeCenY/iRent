//
//  Room.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation

struct Room: Codable {
    
    let id: UUID
    let state: Bool?                          //是否退房
    let room_no: String?                        //房间号
    let rent_money: Int?                          //租金
    let deposit: Int?                                   //押金
    let lease_term: Int?                         //租期
    let rent_date: String?               //收租日期
    let network: Int?                       //网络
    let trash_fee: Int?                             //垃圾费
    let create_at: Date            //创建时间
    let updated_at: Date                //更新时间
    let payment:  [Payment]?
    let tenant: [Tenant]?
    
    
    //详情页面返回值
   func asDetailDict() -> [String: Any] {
        return [
            "id":               self.id,
            "state":            self.state,
            "room_no":          self.room_no,
            "rent_money":       self.rent_money,
            "deposit":          self.deposit,
            "lease_term":       self.lease_term,
            "rent_date":        self.rent_date,
            "network":          self.network,
            "trash_fee":        self.trash_fee,
            "create_at":        self.create_at,
            "updated_at":       self.updated_at
        ]
    }

}
