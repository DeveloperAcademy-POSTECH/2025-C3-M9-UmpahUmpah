import SwiftUI

// View Extension
extension Date {
    var day: Int { Calendar.current.component(.day, from: self) }
}
