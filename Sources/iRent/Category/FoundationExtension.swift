
import Foundation

struct DateFormat {
    static let Date = "yyyy-MM-dd"
    static let DateTime = "yyyy-MM-dd HH:mm:ss ZZZZ"
}

public extension Date {
    
    public func toDateString() -> String {
        return format(DateFormat.Date)
    }
    
    public func toDateTimeString() -> String {
        return format(DateFormat.DateTime)
    }
    
    public func format(_ dateFormat: String = DateFormat.DateTime) -> String {
        return DateFormatter().format(dateFormat: dateFormat).string(from: self)
    }
    
    public init(dateString: String, _ format: String = DateFormat.DateTime) {
        
        let dateFormatter = DateFormatter().format(dateFormat: format)
        guard let date = dateFormatter.date(from: dateString) else {
            self = Date()
            return
        }
        self = date
    }
}

public extension String {

    public func toDate() -> Date? {
        return format(DateFormat.Date)
    }
    
    public func toDateTime() -> Date? {
        return format(DateFormat.DateTime)
    }
    
    func format(_ dateFormat: String = DateFormat.DateTime) -> Date? {
        return DateFormatter().format(dateFormat: dateFormat).date(from: self) as Date?
    }
}

extension DateFormatter {
    
    public func format(dateFormat: String) -> DateFormatter {
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
