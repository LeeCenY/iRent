//
//  Qiniu.swift
//  COpenSSL
//
//  Created by nil on 2018/4/26.
//

import Foundation
import PerfectLib
import PerfectHTTP

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
}
