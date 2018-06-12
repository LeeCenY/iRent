
import Foundation

public extension Date {
    
    public func toDateString() -> String {
        return format(.Date)
    }
    
    public func toDateTimeString() -> String {
        return format(.DateTime)
    }
    
    public func format(_ dateFormat: DateFormatter.Format = .DateTime) -> String {
        return DateFormatter().format(dateFormat: dateFormat.rawValue).string(from: self)
    }
    
    public init(dateString: String, _ format: DateFormatter.Format = .DateTime) {
        
        let dateFormatter = DateFormatter().format(dateFormat: format.rawValue)
        guard let date = dateFormatter.date(from: dateString) else {
            self = Date()
            return
        }
        self = date
    }
}

public extension String {

    public func toDate() -> Date? {
        return format(.Date)
    }
    
    public func toDateTime() -> Date? {
        return format(.DateTime)
    }
    
    func format(_ dateFormat: DateFormatter.Format = .DateTime) -> Date? {
        return DateFormatter().format(dateFormat: dateFormat.rawValue).date(from: self) as Date?
    }
    
    func urlSafeBase64() -> String {
        var base64 = self
        base64 = base64.replacingOccurrences(of: "+", with: "_")
        base64 = base64.replacingOccurrences(of: "/", with: "_")
        return base64
    }
    
}

public extension DateFormatter {
    
    enum Format: String {
        case Date = "yyyy-MM-dd"
        case DateTime = "yyyy-MM-dd HH:mm:ss ZZZZ"
    }

    func format(dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat;
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: -8 * 3600)!;
//        dateFormatter.locale = Locale.current
        return dateFormatter
    }
}


public func calculateDate(day: Int) -> Date? {
    let calendar = Calendar.current
    let currentDate = Date()
    var dateComponents = DateComponents()
    dateComponents.day = day
    return calendar.date(byAdding: dateComponents, to: currentDate)
}

public func calculateDate(date:Date, month:Int) -> Date? {
    let calendar = Calendar.current
    let currentDate = date
    var dateComponents = DateComponents()
    dateComponents.month = month
    return calendar.date(byAdding: dateComponents, to: currentDate)
}


public func calculateDate(month:Int, day: Int) -> Date? {
    let calendar = Calendar.current
    let currentDate = Date()
    var dateComponents = DateComponents()
    dateComponents.month = month
    dateComponents.day = day
    return calendar.date(byAdding: dateComponents, to: currentDate)
}

public func calculateDate(year: Int, month:Int, day: Int) -> Date? {
    let calendar = Calendar.current
    let currentDate = Date()
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    return calendar.date(byAdding: dateComponents, to: currentDate)
}
