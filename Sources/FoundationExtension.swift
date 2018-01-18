
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
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter
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
