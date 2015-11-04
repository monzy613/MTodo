//: Playground - noun: a place where people can play

import UIKit

NSDate()
let daySeconds: NSTimeInterval = 86400
let yesterday = NSDate(timeIntervalSinceNow: -daySeconds * 0.5)
let lastWeekOfThisDay = NSDate(timeIntervalSinceNow: -daySeconds * 8)

func getDateComponents(_date: NSDate) -> NSDateComponents {
    return NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute, .Second, .WeekOfMonth, .WeekOfYear, .Weekday], fromDate: _date)
}

func intervalBetweenDates(start: NSDate, end: NSDate) -> NSTimeInterval {
    return floor(end.timeIntervalSinceDate(start))
}

func dayBetweenDates(start: NSDate, end: NSDate) -> Int {
    let doubleValue: Double = intervalBetweenDates(start, end: end) / daySeconds
    return Int(ceil(doubleValue))
}

func weekForWeekday(weekday: Int) -> String {
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

func dateStringWithNSDate(thenDate: NSDate) -> String {
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

let dateComponents = getDateComponents(yesterday)
dateComponents.year
dateComponents.month
dateComponents.day
dateComponents.hour
dateComponents.minute
dateComponents.second
dateComponents.weekOfMonth
dateComponents.weekOfYear
dateComponents.weekday


dateStringWithNSDate(yesterday)
dateStringWithNSDate(lastWeekOfThisDay)

let str = "2015"
str.substringWithRange(str.startIndex.advancedBy(2)..<str.endIndex)


