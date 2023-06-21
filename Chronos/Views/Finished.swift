//
//  Finished.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 3/29/21.
//

import SwiftUI
import Resolver


struct Finished: View {
    @Injected var workoutsRepository: WorkoutRepository
    @ObservedObject var WorkoutVM: WorkoutViewModel
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Finished!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
                .padding()
            
            List {
                Text("Your workout:")
                    .bold()
                ForEach(WorkoutVM.exerciseViewModels) { exerciseVM in
                    HStack {
                        Text("\(exerciseVM.exercise.setsCompleted)x\(exerciseVM.exercise.reps)")
                        Text(exerciseVM.exercise.name)
                        Spacer()
                        Text("Rest: \(exerciseVM.exercise.restTime)s")
                    }
                    
                }
            }
            
            NavigationLink(
                destination: Launch(),
                label: {
                    Text("Back to launch screen")
                        .underline()
                        .accentColor(.orange)
                        .padding()
                })
            Spacer()
        }
        .navigationBarHidden(true)
    }
}


struct Finished_Previews: PreviewProvider {
    static var previews: some View {
        Finished(WorkoutVM: createTestWorkout())
    }
}
