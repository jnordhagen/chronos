//
//  WorkoutModel.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 3/22/21.
//

import Foundation


struct Workout: Identifiable, Codable {
    var id: String = UUID().uuidString
    var date: Date
    var title: String
    var exercises: Array<Exercise>
    var type: WorkoutType
}


struct Exercise: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var sets: Int
    var reps: Int
    
    var setsCompleted: Int = 0
    var completed: Bool = false
    var restTime: Int
}


enum WorkoutType: Int, Codable {
    case none
    
    case push
    case pull
    case legs
    
    case shoulders
    case arms
    case chest
    case back
    
    case abs
    case cardio
    case bodyweight
}

#if DEBUG

let testDataExercises: [Exercise] = [
    Exercise(name: "Bench press", sets: 5, reps: 5, restTime: 90),
    Exercise(name: "Triceps dip", sets: 3, reps: 12, restTime: 60),
    Exercise(name: "Incline bench press", sets: 4, reps: 8, restTime: 90),
    Exercise(name: "Cable fly", sets: 4, reps: 15, restTime: 60),
    Exercise(name: "Diamond push-up", sets: 3, reps: 20, restTime: 60),
    Exercise(name: "Lateral raise", sets: 3, reps: 10, restTime: 60)
]

#endif

// define presets/templates

func buildFromTemplate(exercises: [Exercise]) -> WorkoutViewModel {
    let workoutVM = WorkoutViewModel()
    for exercise in exercises {
        var newExercise = exercise
        newExercise.setsCompleted = 0
        workoutVM.addExercise(exercise: newExercise)
    }
    return workoutVM
}

func buildFromPrevious(workout: Workout) -> WorkoutViewModel {
    let workoutVM = WorkoutViewModel()
    for exercise in workout.exercises {
        var newExercise = exercise
        newExercise.setsCompleted = 0
        workoutVM.addExercise(exercise: newExercise)
    }
    return workoutVM
}
