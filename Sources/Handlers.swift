import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM
import Foundation

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
                let water:          Int                 = dict["water"]                     as? Int,
                let electric:       Int                 = dict["electric"]                  as? Int,
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
            electricMeters.electricmeter_number = electric
            
            let watermeters = WaterMeters()
            watermeters.watermeter_month = month
            watermeters.watermeter_number = water
            
    
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
            try! response.setBody(json: ["success":false, "status": 200])
            response.completed()
            Log.error(message: "registration : \(error)")
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
            let s = StORMCursor.init(limit: 2, offset: offset)

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
            Log.error(message: "rentlist : \(error)")
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
            Log.error(message: "queryRoomNo : \(error)")
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
                let id: Int             = dict["id"]            as? Int,
                let month: String       = dict["month"]         as? String,
                let electric: Int       = dict["electric"]      as? Int,
                let water: Int          = dict["water"]         as? Int
                else {
                    try response.setBody(json: ["success":false, "status": 200])
                    response.completed()
                    return
            }

            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            
            let tenant = Tenants()
            tenant.id = id
            tenant.updatetime = "\(dateFormatter.string(from: date))"

            let electricObj = ElectricMeters()
            electricObj.tenants_id = id
            electricObj.electricmeter_month   = month
            electricObj.electricmeter_number  = electric
            
            let waterObj = WaterMeters()
            waterObj.tenants_id = id
            waterObj.watermeter_month    = month
            waterObj.watermeter_number   = water

            
           let tenant_updatetime = try tenant.update(
                cols: ["updatetime"],
                params: [tenant.updatetime],
                idName: "id",
                idValue: tenant.id
            )
  
            let electric_insert =  try electricObj.insert(
                cols: ["tenants_id","electricmeter_month","electricmeter_number"],
                params: [electricObj.tenants_id, electricObj.electricmeter_month, electricObj.electricmeter_number]
            )
            
            let water_insert =  try waterObj.insert(
                cols: ["tenants_id","watermeter_month","watermeter_number"],
                params: [waterObj.tenants_id, waterObj.watermeter_month, waterObj.watermeter_number]
            )
            

            try response.setBody(json: ["success":true, "status": 200, "data":
                                                                            ["tenant_updatetime": tenant_updatetime,
                                                                             "electric_id": electric_insert,
                                                                             "water_id": water_insert]])
            response.completed()
            
        } catch {
            try! response.setBody(json: ["success":false, "status": 200])
            response.completed()
            Log.error(message: "update : \(error)")
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


























