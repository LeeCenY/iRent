//
//  Qiniu.swift
//  COpenSSL
//
//  Created by nil on 2018/4/26.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectCRUD

public class Qiniu: BaseHandler {
    
    open static func qiniutoken() -> RequestHandler{
        return {
            request, response in
            do {
                guard let uploadToken = try QiniuConfig().getToken(day: 3) else {
                    resError(request, response, error: "bad Token", code: HTTPResponseStatus.badRequest)
                    return
                }
                
                try response.setBody(json: ["success": true, "status": 200, "data": uploadToken])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "queryRoomNo : \(error)")
            }
        }
    }
    
    open static func qiniuImageURL() -> RequestHandler{
        return {
            request, response in
            do {
                guard
                    let json = request.postBodyString,
                    let dict = try json.jsonDecode() as? [String: Any]
                    else {
                        resError(request, response, error: "请填写请求参数")
                        return
                }
                
                //id
                guard let roomID = UUID.init(uuidString: (dict["room_id"] as? String)!) else {
                    resError(request, response, error: "room_id 请求参数不正确")
                    return
                }
                
                //收租时间
                guard let rentDate: String = dict["rent_date"] as? String, rentDate.toDate() != nil else {
                    resError(request, response, error: "收租时间 rentdate 请求参数不正确")
                    return
                }
                
                //图片链接
                guard let imageURL: String = dict["image_url"] as? String else {
                    resError(request, response, error: "图片链接 image_url 请求参数不正确")
                    return
                }
                
                let roomTable = db().table(Room.self)
                let query = roomTable.where(\Room.id == roomID && \Room.state == false)
                
                guard try query.count() != 0 else {
                    resError(request, response, error: "房间 id 不存在或已经退房")
                    return
                }
                
                let payment = Payment.init(id: UUID(), room_id: UUID(), state: false, payee: nil, rent_date: rentDate, money: nil, rent_money: nil, water: nil, electricity: nil, network: nil, trash_fee:nil, image_url: imageURL, arrears: nil, remark: nil, create_at: Date().iso8601(), updated_at: Date().iso8601())
                
                do {
                    let paymentTable = db().table(Payment.self)
                    try paymentTable
                        .where(\Payment.room_id == roomID && \Payment.rent_date == rentDate)
                        .update(payment, setKeys: \.image_url, \.updated_at)
                } catch  {
                    try response.setBody(json: ["success": true, "status": 200, "data": "\(error)"])
                    response.setHeader(.contentType, value: "application/json")
                    response.completed()
                    return
                }
                
                try response.setBody(json: ["success": true, "status": 200, "data": "添加图片链接成功"])
                response.setHeader(.contentType, value: "application/json")
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "queryRoomNo : \(error)")
            }
        }
    }
}
