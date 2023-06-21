//
//  WorkoutsRepository.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 4/13/21.
//

import Foundation
import Disk


class BaseWorkoutRepository {
    @Published var workouts = [Workout]()
}

protocol WorkoutRepository: BaseWorkoutRepository {
    func addWorkout(_ workout: Workout)
    func removeWorkout(_ workout: Workout)
    func updateWorkout(_ workout: Workout)
    func delete(atOffsets: IndexSet)
}

class LocalWorkoutRepository: BaseWorkoutRepository, WorkoutRepository, ObservableObject {
    override init() {
        super.init()
        loadData()
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        saveData()
    }
    
    func removeWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
            saveData()
            loadData()
        }
    }
    
    func delete(atOffsets indexSet: IndexSet) {
        workouts.remove(atOffsets: indexSet)
        saveData()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = self.workouts.firstIndex(where: { $0.id == workout.id } ) {
            self.workouts[index] = workout
            saveData()
        }
    }
    
    private func loadData() {
        if let retrievedWorkouts = try? Disk.retrieve("workouts.json", from: .documents, as: [Workout].self) {
            self.workouts = retrievedWorkouts
        }
    }
    
    private func saveData() {
        do {
            try Disk.save(self.workouts, to: .documents, as: "workouts.json")
        }
        catch let error as NSError {
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
    }
}
