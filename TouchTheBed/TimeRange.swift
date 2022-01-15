//
//  TimeRange.swift
//  TouchTheBed
//
//  Created by Helen Dun on 1/2/22.
//

import Foundation

class TimeRange {
    var startHour: Int = 23
    var startMin: Int = 30
    var endHour: Int = 10
    var endMin: Int = 0
    
    func printTimeRange() {
        print("Start Hour: \(startHour)")
        print("Start Minute: \(startMin)")
        print("End Hour: \(endHour)")
        print("End Minute: \(endMin)")
    }
    
    func isWithinTimeRange() -> Bool {
        let endHour = (endHour < startHour) ? endHour + 24 : endHour
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        guard let currHour = components.hour else { return false }
        guard let currMin = components.minute else { return false }
        
        let afterStart = isAfter(thisHour: startHour, thisMin: startMin, otherHour: currHour, otherMin: currMin)
        let beforeEnd = isBefore(thisHour: endHour, thisMin: endMin, otherHour: currHour, otherMin: currMin)
        
        let afterStart24 = isAfter(thisHour: startHour, thisMin: startMin, otherHour: currHour + 24, otherMin: currMin)
        let beforeEnd24 = isBefore(thisHour: endHour, thisMin: endMin, otherHour: currHour + 24, otherMin: currMin)
        
        /*
        self.printTimeRange()
        print("End Hour X: \(endHour)")
        print("Curr Hour: \(currHour)")
        print("Curr Minute: \(currMin)")
        print("Is After Start: \(afterStart)")
        print("Is After Start 24: \(afterStart24)")
        print("Is Within Range: \((afterStart && beforeEnd) || (afterStart24 && beforeEnd24))")
        */
        
        return (afterStart && beforeEnd) || (afterStart24 && beforeEnd24)
    }
    
    func isAfter(thisHour: Int, thisMin: Int, otherHour: Int, otherMin: Int) -> Bool {
        return (otherHour > thisHour) || (otherHour == thisHour && otherMin >= thisMin)
    }
    
    func isBefore(thisHour: Int, thisMin: Int, otherHour: Int, otherMin: Int) -> Bool {
        return (otherHour < thisHour) || (otherHour == thisHour && otherMin <= thisMin)
    }
}

