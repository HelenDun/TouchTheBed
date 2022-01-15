//
//  BedtimeTimer.swift
//  TouchTheBed
//
//  Created by Helen Dun on 11/28/21.
//

import Foundation

protocol BedtimeTimerProtocol {
    func timerHasFinished(_ timer: BedtimeTimer)
}

class BedtimeTimer {
    var timer: Timer? = nil
    var startTime: Date?
    let duration: TimeInterval = 600    // 10 minutes = 600 seconds
    var elapsedTime: TimeInterval = 0
    
    var delegate: BedtimeTimerProtocol?
    
    func isOn() -> Bool {
        return (timer != nil)
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerAction()
        }
        timerAction()
    }
    
    func stopTimer() {
        // really just pauses the timer
        timer?.invalidate()
        timer = nil

        timerAction()
    }
    
    func resetTimer() {
        // stop the timer & reset back to start
        timer?.invalidate()
        timer = nil

        startTime = nil
        elapsedTime = 0

        timerAction()
    }
    
    func timerHasFinished() {
        delegate?.timerHasFinished(self)
    }
    
    func timerAction() {
        guard let startTime = startTime else { return }

        elapsedTime = -startTime.timeIntervalSinceNow
        let secondsRemaining = (duration - elapsedTime).rounded()
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timerHasFinished(self)
        }
    }
}
