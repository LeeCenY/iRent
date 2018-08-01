//
//  UploadFile.swift
//  iRent
//
//  Created by nil on 2018/8/1.
//

import Foundation

struct UploadFile: Codable {
    let id: UUID
    let rentDate: String
    let money: Double
    let payee: String
    let token: String
    let state: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case rentDate = "rent_date"
        case money
        case payee
        case token
        case state
    }
}
