//
//  Timer.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 3/26/21.
//

import Foundation
import Resolver


enum StopwatchMode {
    case notStarted
    case running
    case stopped
    case paused
}

class StopwatchManager: ObservableObject {
    @Published var secondsElapsed: Int = 0
    @Published var mode: StopwatchMode = .notStarted
    
    private var interval = 0
    private var whenExited: Date? = nil
    
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.secondsElapsed += 1
        }
    }
    
    func reset() {
        self.secondsElapsed = 0
        if (mode != .running) { start() }
    }
    
    func pause() {
        mode = .paused
        timer.invalidate()
    }
    
    func stop() {
        mode = .stopped
        timer.invalidate()
        self.secondsElapsed = 0
    }
    
    func storeCurrentTime() {
        if (mode == .running) {
            whenExited = Date()
        }
    }
    
    func addTimeInterval() {
        if (mode == .running && whenExited != nil) {
            secondsElapsed += Int(-1 * round(whenExited!.timeIntervalSinceNow))
        }
    }
}
