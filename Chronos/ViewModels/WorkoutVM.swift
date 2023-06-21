//
//  WorkoutVM.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 3/22/21.
//

import Foundation
import Combine
import SwiftUI


class WorkoutViewModel: ObservableObject {
    @Published var exerciseViewModels = [ExerciseViewModel]()
    @Published var workout = Workout(date: Date(), title: "New Workout", exercises: [], type: .none)
    @Published var currentExerciseVM: ExerciseViewModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func addBlankExercise() {
        exerciseViewModels.append(ExerciseViewModel(exercise: Exercise(name: "", sets: 3, reps: 10, restTime: 60)))
    }
    
    func addExercise(exercise: Exercise) {
        exerciseViewModels.append(ExerciseViewModel(exercise: exercise))
    }
    
    func removeExercises(atOffsets indexSet: IndexSet) {
        exerciseViewModels.remove(atOffsets: indexSet)
    }
    
    func syncModel() {
        for exerciseVM in exerciseViewModels {
            workout.exercises.append(exerciseVM.exercise)
        }
    }
    
}


class ExerciseViewModel: ObservableObject, Identifiable {
    @Published var exercise: Exercise
    
    var id: String = ""
    
    private var cancellables = Set<AnyCancellable>()

    static func newExercise() -> ExerciseViewModel {
        ExerciseViewModel(exercise: Exercise(name: "", sets: 3, reps: 10, restTime: 60))
    }
    
    init(exercise: Exercise) {
        self.exercise = exercise
        
        $exercise
            .map { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
}


func createTestWorkout() -> WorkoutViewModel {
    let testWorkoutVM = WorkoutViewModel()
    
    testWorkoutVM.addExercise(exercise: Exercise(name: "Bench press", sets: 5, reps: 5, restTime: 90))
    testWorkoutVM.addExercise(exercise: Exercise(name: "Triceps dip", sets: 3, reps: 12, restTime: 60))
    testWorkoutVM.addExercise(exercise: Exercise(name: "Incline bench press", sets: 4, reps: 8, restTime: 90))
    testWorkoutVM.addExercise(exercise: Exercise(name: "Cable fly", sets: 4, reps: 15, restTime: 60))
    testWorkoutVM.addExercise(exercise: Exercise(name: "Diamond push-up", sets: 3, reps: 20, restTime: 60))
    testWorkoutVM.addExercise(exercise: Exercise(name: "Lateral raise", sets: 3, reps: 10, restTime: 60))
    
    testWorkoutVM.syncModel()
    return testWorkoutVM
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
