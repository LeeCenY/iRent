//
//  Tenant.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation

struct Tenant: Codable {
    
    let id: UUID
    let room_id: UUID                               //房间id
    let state: Bool?                               //是否退房
    let name: String?                                   //姓名
    let idcard: String?                                  //身份证号码
    let phone: String?                             //手机号
    let create_at: String                       //创建时间
    let updated_at: String                        //更新时间
}

