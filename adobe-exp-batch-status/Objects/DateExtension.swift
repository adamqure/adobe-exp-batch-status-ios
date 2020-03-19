//
//  DateExtension.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 3/10/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

extension Date {

    func offsetFrom(date: Date) -> String {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

        let minutes = "\(difference.minute ?? 0) minutes"
        let hours = "\(difference.hour ?? 0) hours"
        let days = "\(difference.day ?? 0) days"

        if let day = difference.day, day          > 0 {
            return "Updated \(days) ago"
        }
        if let hour = difference.hour, hour       > 0 {
            return "Updated \(hours) ago"
        }
        if let minute = difference.minute, minute > 0 {
            return "Updated \(minutes) ago"
        }
        return "Updated Recently"
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

}
