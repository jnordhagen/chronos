//
//  StreakManager.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 5/16/21.
//

import Foundation
import SwiftUI


class streakManager: ObservableObject {
    @Published var streakCount: Int = 0
    
    init(lastDate: Date) {
        let calendar = Calendar.autoupdatingCurrent
        if (calendar.isDateInToday(lastDate) || calendar.isDateInYesterday(lastDate)) {
            streakCount += 1
        } else {
            streakCount = 0
        }
        
    }
}
