//
//  StartWorkout.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 3/27/21.
//

import SwiftUI
import Resolver

func timeFormat(seconds: Int) -> String {
    let m = seconds / 60
    let s = seconds % 60
    return s < 10 ? "\(m):0\(s)" : "\(m):\(s)"
}


struct StartWorkout: View {
    @ObservedObject var WorkoutVM: WorkoutViewModel
    @ObservedObject var stopwatchManager = StopwatchManager()
    @Injected var workoutsRepository: WorkoutRepository
    @State private var showEndAlert = false
    @State private var activateFinishedLink = false

    
    var body: some View {
//        NavigationView {
            VStack(alignment: .center) {
                VStack {
                    Text("Rest time: ")
                        .padding(.top, 30)
                    Text(timeFormat(seconds: stopwatchManager.secondsElapsed))
                        .font(Font.monospacedDigit(Font.system(size: 50).weight(.light))())
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in // going to background
                        stopwatchManager.storeCurrentTime()
                    }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in // coming back to foreground
                        stopwatchManager.addTimeInterval()
                    }
                
                List {
                    ForEach(WorkoutVM.exerciseViewModels) { exerciseVM in
                        exerciseView(exerciseVM: exerciseVM, stopwatchManager: stopwatchManager)
                    }
                }
                
                ZStack {
                    if (stopwatchManager.mode == .running) {
                        Button(action: {self.stopwatchManager.pause()}) {
                            Text("Pause")
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(20)
                                .compositingGroup()
                                .clipped()
                                .padding(.bottom, 10)
                        }.buttonStyle(PlainButtonStyle())
                        
                    }
                    if (stopwatchManager.mode == .paused) {
                        HStack {
                            Spacer()
                            Button(action: {self.stopwatchManager.start()}) {
                                Text("Resume")
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(20)
                                    .compositingGroup()
                                    .clipped()
                            }.buttonStyle(PlainButtonStyle())
                            Spacer()
                            Button(action: {showEndAlert = true} ) {
                                Text("End")
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(20)
                                    .compositingGroup()
                                    .clipped()
                            }
                            .alert(isPresented: $showEndAlert, content: {
                                Alert(
                                    title: Text("End session?"),
                                    message: Text("There is no going back."),
                                    primaryButton: .destructive(Text("End")) {
                                        WorkoutVM.syncModel()
                                        workoutsRepository.addWorkout(WorkoutVM.workout)
                                        self.activateFinishedLink = true
                                    },
                                    secondaryButton: .cancel()
                                )
                            })
                            Spacer()
                        }
                        .padding(.bottom, 10)
                    }
                    NavigationLink(destination: Finished(WorkoutVM: WorkoutVM), isActive: $activateFinishedLink,
                                        label: { EmptyView() })
                       
                    
                } // ZStack
                
            } // VStack
            .navigationBarHidden(true)
//        } // NavigationView
//        .navigationBarHidden(true)
    }
}


struct exerciseView: View {
    @ObservedObject var exerciseVM: ExerciseViewModel
    @ObservedObject var stopwatchManager: StopwatchManager
    
    var body: some View {
        HStack {
            Button(action: {
                exerciseVM.exercise.setsCompleted += 1
                stopwatchManager.mode == .notStarted ? stopwatchManager.start() : stopwatchManager.reset()
            }) {
                Text("\(exerciseVM.exercise.setsCompleted)/\(exerciseVM.exercise.sets)")
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            Text("x\(exerciseVM.exercise.reps)")
            //                add chalkduster font
            Text(exerciseVM.exercise.name == "" ? "Unnamed" : exerciseVM.exercise.name)
            
            Spacer()
            Button(action: {
                if (exerciseVM.exercise.setsCompleted > 0) { exerciseVM.exercise.setsCompleted -= 1 }
                stopwatchManager.reset()
            }) {
                Image(systemName: "arrow.uturn.backward")
                    .opacity(exerciseVM.exercise.setsCompleted > 0 ? 0.3: 0)
                    .compositingGroup()
                    .clipped()
            }.buttonStyle(PlainButtonStyle())
        }
    }
}


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.3 : 1)
    }
}


struct StartWorkout_Previews: PreviewProvider {
    
    static var previews: some View {
        StartWorkout(WorkoutVM: createTestWorkout())
    }
}
