//
//  DayNightTimer.swift
//  TouchTheBed
//
//  Created by Helen Dun on 1/2/22.
//

import Foundation

class DayNightTimer {
    var timer: Timer? = nil
    var timeRange: TimeRange? = nil
    var bedtimeTimer: BedtimeTimer? = nil
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            self.timerAction()
        }
        self.timerAction()
    }
    
    deinit {
      timer?.invalidate()
      timer = nil
    }
    
    func timerAction() {
        guard let btt = bedtimeTimer else { return }
        guard let isWithinBedtime = timeRange?.isWithinTimeRange() else { return }
        
        if isWithinBedtime && !btt.isOn() {
            btt.timerHasFinished()
            btt.startTimer()
        }
        else if !isWithinBedtime && btt.isOn() {
            btt.resetTimer()
        }
    }
    
    
}
