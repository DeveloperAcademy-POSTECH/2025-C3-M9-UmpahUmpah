//
//  TimeInterval+Extension.swift
//  UmpahUmpah
//
//  Created by yunsly on 6/6/25.
//

import Foundation

extension TimeInterval {
    /// 3661 → "01:01:01"
    var hhmmssString: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    /// 3661 → "1′ 1″ 1‴" or "1′ 1″" style
    var readableMinuteSecond: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return "\(minutes)′ \(seconds)″"
    }
}
