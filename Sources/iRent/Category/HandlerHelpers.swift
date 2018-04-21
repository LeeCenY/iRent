import PerfectHTTP

extension BaseHandler {
    
    static func resError(_ request: HTTPRequest, _ response: HTTPResponse, error: String, code: HTTPResponseStatus = .badRequest) {
        do {
            try response.setBody(json: ["success": false, "status": code.description , "data": "\(error)"])
        } catch {
            print(error)
        }
        response.completed()
    }

    static func unimplemented(data: [String:Any]) throws -> RequestHandler {
        return {
            request, response in
            response.status = .notImplemented
            response.completed()
        }
    }

    // 服务器内部错误处理
    static func serverErrorHandler(_ request: HTTPRequest, _ response: HTTPResponse)
    {
//        try! response.setBody(json: ["success": false, "status": HTTPResponseStatus.serviceUnavailable])
//        response.completed()
    }
}




