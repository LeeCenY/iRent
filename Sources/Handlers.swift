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
    open static func registration(_ request: HTTPRequest, _ response: HTTPResponse) {
        do {
            guard
                let json = request.postBodyString,
                let dict = try json.jsonDecode() as? [String : Any],
                let mobilePhoneNumber = dict["mobilePhoneNumber"],
                let idCardNumber = dict["idCardNumber"],
                let roomNumber = dict["roomNumber"],
                let water = dict["water"] else {
                    try response.setBody(json: ["susuu":false, "code": "200"])
                    response.completed()
                    return
            }
            
            let tenants = Tenants()
            tenants.mobilePhoneNo = mobilePhoneNumber as! String
            tenants.idNumber = idCardNumber as! String
            tenants.roomNumber = roomNumber as! String
            tenants.water = water as! [Dictionary<String, String>]
            
            do {
                try tenants.save()
                try response.setBody(json: ["susuu":true, "code": "200"])
                response.completed()
            } catch {
                try response.setBody(json: ["susuu":false, "code": "200"])
                response.completed()
            }
        } catch {
            try! response.setBody(json: ["susuu":false, "code": "200"])
            response.completed()
        }
    }

    /// 收租信息列表
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func rentlist(_ request: HTTPRequest, _ response: HTTPResponse) {
        //创建连接
        let client = try! MongoClient(uri: "mongodb://localhost:27017")
        
        //连接到具体的数据库，假设有个数据库名字叫 test
        let db = client.getDatabase(name: "user")
        
        //定义集合
        guard let collection = db.getCollection(name: "tenants") else { return }
        
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
    
    
    /// 更新水电数据
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func update(_ request: HTTPRequest, _ response:HTTPResponse) {
        do {
            guard
                let json = request.postBodyString,
                let dict = try json.jsonDecode() as? [String : Any],
                let id = dict["id"],
                let water = dict["water"],
                let electricity = dict["electricity"] else {
                    try response.setBody(json: ["susuu":false, "code": "200"])
                    response.completed()
                    return
            }
            
            let tenants = Tenants()
            tenants.id = id as! String
            tenants.water = water as! [Dictionary<String, String>]
            tenants.electricity = electricity as! [Dictionary<String, String>]
            do {
                try tenants.save()
                try response.setBody(json: ["susuu":true, "code": "200"])
                response.completed()
                
            } catch {
                throw error
            }
            
        } catch {
            try! response.setBody(json: ["susuu":false, "code": "200"])
            response.completed()
        }
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


























