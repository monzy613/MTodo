//
//  DateTool.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/4.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class DateTool: NSObject {
    
    static let daySeconds: NSTimeInterval = 86400
    
    class func getDateComponents(_date: NSDate) -> NSDateComponents {
        return NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute, .Second, .WeekOfMonth, .WeekOfYear, .Weekday], fromDate: _date)
    }
    
    class func intervalBetweenDates(start: NSDate, end: NSDate) -> NSTimeInterval {
        return floor(end.timeIntervalSinceDate(start))
    }
    
    class func dayBetweenDates(start: NSDate, end: NSDate) -> Int {
        let doubleValue: Double = intervalBetweenDates(start, end: end) / daySeconds
        return Int(ceil(doubleValue))
    }
    
    class func weekForWeekday(weekday: Int) -> String {
        var weekDayString: String
        switch weekday {
        case 0:
            weekDayString = "Sun"
        case 1:
            weekDayString = "Mon"
        case 2:
            weekDayString = "Tue"
        case 3:
            weekDayString = "Wed"
        case 4:
            weekDayString = "Thu"
        case 5:
            weekDayString = "Fri"
        case 6:
            weekDayString = "Sat"
        default:
            weekDayString = "NIL"
        }
        return weekDayString
    }
    
    class func dateStringWithNSDate(thenDate: NSDate) -> String {
        let currentDate = NSDate()
        let current = getDateComponents(currentDate)
        let then = getDateComponents(thenDate)
        let dayInterval = dayBetweenDates(thenDate, end: currentDate)
        
        if dayInterval <= 1 {
            if then.day == current.day {
                return "\(then.hour):\(then.minute)"
            } else {
                return "yesterday"
            }
        }
        
        if dayInterval == 2 {
            return "yesterday"
        }
        
        if dayInterval <= 7 {
            return weekForWeekday(then.weekday)
        }
        
        let ystr = "\(then.year)"
        let yearString = ystr.substringWithRange(ystr.startIndex.advancedBy(2)..<ystr.endIndex)
        
        return "\(yearString)/\(then.month)/\(then.day)"
    }
}
