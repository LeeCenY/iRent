import PerfectLib
import PerfectHTTP
import MongoDB

///请求处理
public class WebHandlers {

    /// 登记信息
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func registrationPost(request: HTTPRequest, response: HTTPResponse) {
        
        //    guard let mobilePhoneNumber = request.param(name: "mobilePhoneNumber"),
        //        let idCardNumber = request.param(name: "idCardNumber"),
        //        let roomNumber = request.param(name: "roomNumber"),
        //        let waterNumber = request.param(name: "waterNumber"),
        //        let electricityNumber = request.param(name: "electricityNumber"),
        //        let rent = request.param(name: "rent"),
        //        let deposit = request.param(name: "deposit"),
        //        let network = request.param(name: "network"),
        //        let trashFee = request.param(name: "trashFee"),
        //        let registrationTime = request.param(name: "registrationTime")else {
        //            response.setBody(string: "错误")
        //            response.completed()
        //            return
        //    }
        
        //    let responsDic: [String: Any] = ["result":["mobilePhoneNumber": mobilePhoneNumber,
        //                                               "idCardNumber": idCardNumber,
        //                                               "roomNumber": roomNumber,
        //                                               "waterNumber": waterNumber,
        //                                               "electricityNumber": electricityNumber,
        //                                               "rent": rent, "deposit": deposit,
        //                                               "network": network,
        //                                               "trashFee": trashFee,
        //                                               "registrationTime": registrationTime,
        //                                               "rentTime": rentTime],
        //                                     "status": "200"]
        
        
        let responsDic: [String: Any] = ["result":["mobilePhoneNumber": "mobilePhoneNumber",
                                                   "idCardNumber": "mobilePhoneNumber",
                                                   "roomNumber": "mobilePhoneNumber",
                                                   "waterNumber": "mobilePhoneNumber",
                                                   "electricityNumber": "mobilePhoneNumber",
                                                   "rent": "mobilePhoneNumber", "deposit": "mobilePhoneNumber",
                                                   "network": "mobilePhoneNumber",
                                                   "trashFee": "mobilePhoneNumber",
                                                   "registrationTime": "mobilePhoneNumber",
                                                   "rentTime": "mobilePhoneNumber"],
                                         "status": "200"]
        
        
        do {
            try response.setBody(json: responsDic)
        } catch {
            response.setBody(string: "josn转换错误")
        }
        response.completed()
    
    }
    
    /// 收租信息列表
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func rentInformationGet(request: HTTPRequest, response: HTTPResponse) {
        
        
    }
    
    open static func lineMongoDB(request: HTTPRequest, response: HTTPResponse) {
        
        //创建连接
        let client = try! MongoClient(uri: "mongodb://localhost:2701")
        
        //连接到具体的数据库，假设有个数据库名字叫 test
        let db = client.getDatabase(name: "tests")
        
        //定义集合
        guard let collection = db.getCollection(name: "testcollection") else { return }
        
        //在关闭连接时注意关闭顺序与启动顺序相反
        defer {
            collection.close()
            db.close()
            client.close()
        }

        //执行查询
        let fnd = collection.find(query: BSON())
        
        //初始化一个空数组用于存放结果记录集
        var arr = [String]()
        
        // fnd 游标是一个 mongoCursor 类型，用于遍历结果
        for x in fnd! {
            arr.append(x.asString)
        }
        
        
        // 返回一个格式化的 JSON 数组。
        let returning = "{\"data\":[\(arr.joined(separator: ","))]}"
        
        //返回 JSON 字符串
        response.appendBody(string: returning)
        response.completed()
        
        
    }
    
    open static func saveMongoDB(request: HTTPRequest, response: HTTPResponse) {
        
        //创建连接
        let client = try! MongoClient(uri: "mongodb://localhost:2701")
        
        //连接到具体的数据库，假设有个数据库名字叫 test
        let db = client.getDatabase(name: "tests")
        
        //定义集合
        guard let collection = db.getCollection(name: "testcollection") else { return
        }

        //定义BSON对象，从请求的body部分取JSON对象
        let bson = try! BSON(json: request.postBodyString!)
        
        //在关闭连接时注意关闭顺序与启动顺序相反，类似栈
        defer {
            bson.close()
            collection.close()
            db.close()
            client.close()
        }
        
        let result = collection.save(document: bson)

        response.setHeader(.contentType, value: "application/json")
        response.appendBody(string: "\(result)")
        response.completed()
    }

}

struct Filter404: HTTPResponseFilter {
    
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if case .notFound = response.status {
            response.bodyBytes.removeAll()
            response.setBody(string: "\(response.request.path) is not found")
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            callback(.done)
        }else {
            callback(.continue)
        }
        
        
    }
    
}


























