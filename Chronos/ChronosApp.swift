//
//  ChronosApp.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 3/15/21.
//

import SwiftUI
import Resolver


extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    register { LocalWorkoutRepository() as WorkoutRepository }.scope(.application)
  }
}


@main
struct ChronosApp: App {
    var workoutsRepository: WorkoutRepository = Resolver.resolve()
    
    var body: some Scene {
        WindowGroup {
            Launch()
        }
    }
}
