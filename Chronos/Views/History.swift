//
//  History.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 5/6/21.
//

import SwiftUI
import Resolver


struct History: View {
    @Injected var workoutRepository: WorkoutRepository
    
    var body: some View {
        List {
            ForEach(workoutRepository.workouts) { workout in
                NavigationLink(destination: historyDetail(workout: workout)) {
                    workoutItem(workout: workout)
                }
            }
            .onDelete(perform: { indexSet in
                workoutRepository.delete(atOffsets: indexSet)
            })
        }
        .navigationBarTitle("Previous Routines")
    }
}


func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: date)
}

struct workoutItem: View {
    var workout: Workout
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.title)
                .font(.headline)
            HStack {
                Text(formatDate(date: workout.date))
                    .font(.subheadline)
                Text("(\(workout.exercises.count) exercises)")
                    .font(.subheadline)
            }
        }
    }
}


struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
