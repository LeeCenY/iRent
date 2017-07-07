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
                let waterNumber = dict["waterNumber"],
                let electricityNumber = dict["electricityNumber"],
                let rent = dict["rent"] else {
                    response.setBody(string: "错误")
                    response.completed()
                    return
            }
            
            //创建连接
            let client = try! MongoClient(uri: "mongodb://localhost:27017")
            
            //连接到具体的数据库，假设有个数据库名字叫 test
            let db = client.getDatabase(name: "rent")
            
            //定义集合
            guard let collection = db.getCollection(name: "testcollection") else { return }
            
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
            
            var resultString: String
            switch result {
            case MongoCollection.Result.success:
                resultString = "success"
            case MongoCollection.Result.error:
                resultString = "error"
            default:
                resultString = "other"
            }
            
            let _ = try? response.setBody(json: ["result":resultString, "code": 200])
            
            response.setHeader(.contentType, value: "application/json")
            response.completed()
            
        } catch {
            response.setBody(string: "没值")
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
        let db = client.getDatabase(name: "rent")
        
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
    
//    BSON。appendArray（key：< String >，array：< BSON >）
    open static func update(_ request: HTTPRequest, _ response:HTTPResponse) {
        
        let client = try! MongoClient.init(uri: "mongodb://localhost:27017")
        let db = client.getDatabase(name: "rent")
        guard let collection = db.getCollection(name: "testcollection") else{ return }
    
        let bson = BSON()
        let bsons = BSON()
        
        defer {
            bsons.close()
            bson.close()
            collection.close()
            db.close()
            client.close()
        }
        
        guard let id = request.param(name: "_id"),
              let rent = request.param(name: "rent"),
              let electricityNumber = request.param(name: "electricityNumber")
            else {
                response.appendBody(string: "ccccccccccc")
                response.completed()
            return
        }
        
        bson.append(oid: BSON.OID.init(id))

        //执行查询
        let fnd = collection.find(query: bson)

        //初始化一个空数组用于存放结果记录集
        var arr = [String]()
        
        // fnd 游标是一个 mongoCursor 类型，用于遍历结果
        for x in fnd! {
            arr.append(x.asString)
        }
        
        
        // 返回一个格式化的 JSON 数组。
        let returning = "{\"data\":[\(arr.joined(separator: ","))]}"
        
  
        bsons.append(key: "rent", string: rent)
        bsons.append(key: "electricityNumber", string: electricityNumber)
        
        
        let ruste = collection.update(selector: bson, update: bsons)
        
        //返回 JSON 字符串
        response.appendBody(string: returning)
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


























