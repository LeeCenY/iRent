
import Foundation

extension Date {
    public func string() ->String {
        return dateFormatter().string(from: self)
    }
    
    public func day() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
}

extension String {
    public func date() -> Date? {
        return dateFormatter().date(from: self)
    }
}

func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000 +z"
    let local = Locale.init(identifier: "zh")
    dateFormatter.locale = local
    return dateFormatter
}
