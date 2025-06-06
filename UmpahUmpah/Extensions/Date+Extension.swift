import SwiftUI


// Date ex
extension Date {
    func formattedTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd."
        return formatter.string(from: Date())
    }
    
    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}

