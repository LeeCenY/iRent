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
                let json:           String              = request.postBodyString,
                let dict:           [String: Any]       = try json.jsonDecode()             as? [String : Any],
                let idcardnumber:   String              = dict["idcardnumber"]              as? String,
                let phonenumber:    String              = dict["phonenumber"]               as? String,
                let roomnumber:     String              = dict["roomnumber"]                as? String,
                let leaseterm:      String              = dict["leaseterm"]                 as? String,
                let rent:           String              = dict["rent"]                      as? String,
                let deposit:        String              = dict["deposit"]                   as? String,
                let renttime:       Int                 = dict["renttime"]                  as? Int,
                let internet:       Bool                = dict["internet"]                  as? Bool,
                let trashfee:       Bool                = dict["trashfee"]                  as? Bool,
                let water:          String              = dict["water"]                as? String,
                let electric:       String              = dict["electric"]                  as? String,
                let month:          String              = dict["month"]                     as? String
                else {
                    try response.setBody(json: ["success":false, "status": 200, "data": "参数没填完整"])
                    response.completed()
                    return
            }

            
            let tenants = Tenants()
            tenants.uuid            = UUID.init().string
            tenants.idcardnumber    = idcardnumber
            tenants.phonenumber     = phonenumber
            tenants.roomnumber      = roomnumber
            tenants.leaseterm       = leaseterm
            tenants.rent            = rent
            tenants.deposit         = deposit
            tenants.renttime        = renttime
            tenants.internet        = internet ? 1 : 0
            tenants.trashfee        = trashfee ? 1 : 0
            
            
            let electricMeters = ElectricMeters()
            electricMeters.electricmeter_month = month
            electricMeters.electricmeter_number = Int(electric)!
            
            let watermeters = Watermeters()
            watermeters.watermeter_month = month
            watermeters.watermeter_number = Int(water)!
            
            do {
                try tenants.save { id in
                    tenants.id = id as! Int
                }
                
                electricMeters.tenants_id = tenants.id
                try electricMeters.save { id in
                    electricMeters.id = id as! Int
                }
                
                watermeters.tenants_id = tenants.id
                try watermeters.save { id in
                    watermeters.id = id as! Int
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
            var offset = 0
            if let page = request.param(name: "page") {
                offset = Int(page)!
                offset = (offset - 1) * 2
            }

            let tenants = Tenants()
            let s = StORMCursor.init(limit: 20, offset: offset)

            try tenants.select(columns: [], whereclause: "id", params: [], orderby: [], cursor: s, joins: [], having: [], groupBy: [])
            
            var tenantsArray: [[String: Any]] = []
            for row in tenants.rows() {
                tenantsArray.append(row.asDict() as [String : Any])
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
                tenantsArray.append(row.asDict() as [String : Any])
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
                let id: String          = dict["id"]            as? String,
                let month: String       = dict["month"]         as? String,
                let electric: String    = dict["electric"]      as? String,
                let water: String       = dict["water"]         as? String
                else {
                    try response.setBody(json: ["success":false, "status": 200])
                    response.completed()
                    return
            }
            
            let obj = ElectricMeters()
            obj.tenants_id = Int(id)!
            obj.electricmeter_month   = month
            obj.electricmeter_number  = Int(electric)!
            
            let obs = Watermeters()
            obs.tenants_id = Int(id)!
            obs.watermeter_month    = month
            obs.watermeter_number   = Int(water)!

            do {
                let s =  try obj.insert(
                    cols: ["tenants_id","electricmeter_month","electricmeter_number"],
                    params: [obj.tenants_id, obj.electricmeter_month, obj.electricmeter_number]
                )
                
                let ss =  try obs.insert(
                    cols: ["tenants_id","watermeter_month","watermeter_number"],
                    params: [obs.tenants_id, obs.watermeter_month, obs.watermeter_number]
                )
                
                print(ss)
                
                print(s)
                try response.setBody(json: ["success":true, "status": 200])
                response.completed()
                
            } catch {
                try! response.setBody(json: ["success":false, "status": 200])
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


























