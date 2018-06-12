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

    func asDetailDict() -> [String: Any] {
        return [
            "id":               "\(self.id)",
            "room_id":          "\(self.room_id)",
            "state":            self.state,
            "rent_money":       self.rent_money ?? 0,
            "payee":            self.payee ?? 0,
            "rent_date":        self.rent_date,
            "money":            self.money ?? "",
            "rent_money":       self.rent_money ?? 0,
            "water":            self.water ?? 0,
            "electricity":      self.electricity ?? 0,
            "trash_fee":        self.trash_fee ?? 0,
            "arrears":          self.arrears ?? 0,
            "remark":           self.remark ?? "",
            "create_at":        self.create_at,
            "updated_at":       self.updated_at,
        ]
    }
}

