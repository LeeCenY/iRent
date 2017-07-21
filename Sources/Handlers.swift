import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM

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
                let json: String                    = request.postBodyString,
                let dict: [String: Any]             = try json.jsonDecode()     as? [String : Any],
                let idcardnumber: String            = dict["idcardnumber"]      as? String,
                let phonenumber: String             = dict["phonenumber"]       as? String,
                let roomnumber: String              = dict["roomnumber"]        as? String,
                let leaseterm: Int                  = dict["leaseterm"]         as? Int,
                let rent: Int                       = dict["rent"]              as? Int,
                let deposit: Int                    = dict["deposit"]           as? Int,
                let renttime: Int                   = dict["renttime"]          as? Int,
                let internet: Bool                  = dict["internet"]          as? Bool,
                let trashfee: Bool                  = dict["trashfee"]          as? Bool,
                let meter: [[String: String]]       = dict["meter"]             as? [[String: String]],
                let watermeter: [[String: String]]  = dict["watermeter"]        as? [[String: String]]
                else {
                    try response.setBody(json: ["success":false, "status": 200, "data": "参数没填完整"])
                    response.completed()
                    return
            }
            
            let tenants = Tenants()
            tenants.idcardnumber    = idcardnumber
            tenants.phonenumber     = phonenumber
            tenants.roomnumber      = roomnumber
            tenants.leaseterm       = leaseterm
            tenants.rent            = rent
            tenants.deposit         = deposit
            tenants.renttime        = renttime
            tenants.internet        = internet
            tenants.trashfee        = trashfee
            tenants.meter           = meter
            tenants.watermeter      = watermeter
            
            do {
                try tenants.save { id in
                    tenants.id = id as! Int
                }
                try response.setBody(json: ["success":true, "status": 200])
                response.completed()
            } catch {
                try response.setBody(json: ["success":false, "status": 200])
                response.completed()
            }
        } catch {
            try! response.setBody(json: ["success":false, "status": 200])
            response.completed()
        }
    }
    
    /// 收租信息列表
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func rentlist(_ request: HTTPRequest, _ response: HTTPResponse) {
        do {
            let tenants = Tenants()
            try tenants.findAll()
            var tenantsArray: [[String: Any]] = []
            for row in tenants.rows() {
                tenantsArray.append(row.asDictionary() as [String : Any])
            }
            
            var result = [String: Any]()
            result.updateValue(200, forKey: "status")
            result.updateValue(true, forKey: "message")
            result.updateValue(tenantsArray, forKey: "data")
            
            guard let jsonString = try? result.jsonEncodedString() else {
                try! response.setBody(json: ["success":false, "status": 200])
                response.completed()
                return
            }
            
            response.setBody(string: jsonString)
            response.setHeader(.contentType, value: "appliction/json")
            response.completed()
        } catch {
            try! response.setBody(json: ["success":false, "status": 200])
            response.completed()
        }
        
    }
    
    
    /// 查询房间住户信息
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func queryRoomNo(_ request: HTTPRequest, _ response: HTTPResponse) {
        do {
            guard let roomnumber = request.param(name: "roomnumber") else {
                try response.setBody(json: ["success":false, "status": 200])
                response.completed()
                return
            }
            
            var queryRoomNo = [String: Any]()
            queryRoomNo.updateValue(roomnumber, forKey: "roomnumber")
            
            let tenants = Tenants()
            try tenants.find(queryRoomNo)
            
            var tenantsArray: [[String: Any]] = []
            for row in tenants.rows() {
                tenantsArray.append(row.asDictionary() as [String : Any])
            }
            
            var result = [String: Any]()
            result.updateValue(200, forKey: "status")
            result.updateValue(true, forKey: "message")
            result.updateValue(tenantsArray, forKey: "data")
            
            try response.setBody(json: result)
            response.completed()
        } catch {
            try! response.setBody(json: ["success":false, "status": 200])
            response.completed()
        }
        
    }
    
    
    /// 更新水电数据
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    open static func update(_ request: HTTPRequest, _ response: HTTPResponse) {
        do {
            guard
                let json = request.postBodyString,
                let dict = try json.jsonDecode() as? [String : Any],
                let id: Int = dict["id"] as? Int,
                let meter: [[String: String]] = dict["meter"] as? [[String : String]],
                let watermeter: [[String: String]] = dict["watermeter"] as? [[String : String]]
                else {
                    try response.setBody(json: ["success":false, "status": 200])
                    response.completed()
                    return
            }
            
            let obj = Tenants()
            obj.id = id
            obj.watermeter = meter
            obj.meter = watermeter
            
            do {
                try obj.save { id in
                    obj.id = id as! Int
                }
                
                try response.setBody(json: ["success":true, "status": 200])
                response.completed()
                
            } catch {
                try! response.setBody(json: ["success":false, "code": 200])
                response.completed()
            }
        } catch {
            try! response.setBody(json: ["success":false, "status": 200])
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


























