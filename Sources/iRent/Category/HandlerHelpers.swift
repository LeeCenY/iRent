import PerfectHTTP
import StORM

extension BaseHandler {
    
	static func error(_ request: HTTPRequest, _ response: HTTPResponse, error: String, code: HTTPResponseStatus = .badRequest) {
		do {
			response.status = code
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

	static func nestedDataDict(_ rows: [StORM]) -> [Any] {
		var d = [Any]()
		for i in rows {
			d.append(i.asDataDict())
		}
		return d
	}
    
    // 服务器内部错误处理
    static func serverErrorHandler(_ request: HTTPRequest, _ response: HTTPResponse)
    {
        try! response.setBody(json: ["success": false, "status": HTTPResponseStatus.serviceUnavailable])
        response.completed()
    }
}


