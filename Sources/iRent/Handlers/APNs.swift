//
//  APNs.swift
//  iRent
//
//  Created by nil on 2018/7/14.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectCRUD
import PerfectNotifications

public class APNs: BaseHandler {
    
    static func add() -> RequestHandler {
        return {
            request, response in
            do {
                let userReq = try request.decode(User.self)
                
                guard !userReq.deviceid.isEmpty else {
                    resError(request, response, error: "deviceid 请求参数不正确")
                    return
                }

                guard !userReq.token.isEmpty else {
                    resError(request, response, error: "token 请求参数不正确")
                    return
                }
                
                let userDB = db().table(User.self)

                let isDeviceid = userDB.where(\User.deviceid == userReq.deviceid)
                
                if try isDeviceid.count() == 0 {
                    do { try userDB
                            .insert(userReq)
                    } catch  {
                        resError(request, response, error: "添加失败")
                    }
                    try response.setBody(json: ["success": true, "status": 200, "data": "添加成功"])
                    response.completed()
                    return
                }
                
                do {
                    try userDB
                        .where(\User.deviceid == userReq.deviceid)
                        .update(userReq, setKeys: \.deviceid, \.token)
                    
                } catch  {
                    resError(request, response, error: "添加失败")
                }

                try response.setBody(json: ["success": true, "status": 200, "data": "添加成功"])
                response.completed()
            }catch {
                resError(request, response, error: "请求参数类型不对")
            }
        }
    }
    
}
