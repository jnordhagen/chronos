//
//  historyDetail.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 5/16/21.
//

import SwiftUI

struct historyDetail: View {
    var workout: Workout
    var body: some View {
        
        VStack {
            List {
                ForEach(workout.exercises) { exercise in
                    Text("\(exercise.sets)x\(exercise.reps) \(exercise.name)")
                }
            }
            .navigationBarTitle(Text(workout.title + " (" + formatDate(date: workout.date) + ")"))
            
            Spacer()
            
            NavigationLink(destination: WorkoutList(WorkoutVM: buildFromPrevious(workout: workout))) {
                Text("Use this routine")
                    .padding()
            }
        }
        .navigationBarTitle("Hello")
    }
}

struct historyDetail_Previews: PreviewProvider {
    static var previews: some View {
        historyDetail(workout: createTestWorkout().workout)
    }
}
