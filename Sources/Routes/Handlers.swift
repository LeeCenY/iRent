import PerfectLib
import PerfectHTTP

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
}
