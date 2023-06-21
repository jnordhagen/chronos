//
//  WorkoutList.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 3/22/21.
//

import SwiftUI


struct WorkoutList: View {
    @ObservedObject var WorkoutVM: WorkoutViewModel
    @State var showEditWindow = false
    @State var currentExerciseVM = ExerciseViewModel(exercise: Exercise(name: "", sets: 0, reps: 0, restTime: 0))
    
    var body: some View {
        ZStack {
            
            VStack {
                
                List {
                    ForEach(self.WorkoutVM.exerciseViewModels) { exerciseVM in
                        Cell(exerciseVM: exerciseVM, WorkoutVM: WorkoutVM, isEditingNumbers: $showEditWindow, currentVM: $currentExerciseVM)
                    }
                    .onMove { (indexSet, index) in
                        self.WorkoutVM.exerciseViewModels.move(fromOffsets: indexSet, toOffset: index)
                    }
                    .onDelete { indexSet in
                        self.WorkoutVM.removeExercises(atOffsets: indexSet)
                    }
                }
                .navigationBarItems(leading:
                                        Text(WorkoutVM.workout.title)
                                        .font(.title)
                                        .bold()
                                        .padding()
                                    , trailing:
                                        EditButton()
                                        .opacity(WorkoutVM.exerciseViewModels.isEmpty ? 0 : 1)
                )
                
                HStack {
                    
                    Button(action: {
                        self.WorkoutVM.addBlankExercise()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Add exercise")
                                .bold()
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: StartWorkout(WorkoutVM: WorkoutVM),
                        label: {
                            HStack {
                                Image(systemName: "paperplane.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Start workout")
                                    .bold()
                            }
                            .padding()
                            .accentColor(.green)
                        })
                }
                
            }
            .blur(radius: showEditWindow ? 0 : 0)
            
            if (showEditWindow) {
                EditNumbersWindow(exerciseVM: currentExerciseVM, showing: $showEditWindow)
                    .zIndex(1)
            }
        } // ZStack
    }
}


struct Cell: View {
    @ObservedObject var exerciseVM: ExerciseViewModel
    @ObservedObject var WorkoutVM: WorkoutViewModel
    @Binding var isEditingNumbers: Bool
    @Binding var currentVM: ExerciseViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                hideKeyboard()
                currentVM = exerciseVM
                isEditingNumbers.toggle()
            }) {
                Text("\(exerciseVM.exercise.sets)x\(exerciseVM.exercise.reps)")
                    .compositingGroup()
                    .clipped()
            }
            TextField("Enter exercise name", text: $exerciseVM.exercise.name, onCommit: {
                if !exerciseVM.exercise.name.isEmpty {
//                    WorkoutVM.addBlankExercise()
                }
            })
        }
    }
}

struct EditWorkoutWindow: View {
    @ObservedObject var WorkoutVM: WorkoutViewModel
    @Binding var showing: Bool
    
    let typeOptions = ["Push", "Pull", "Legs", "Other"]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(UIColor.systemBackground)
                VStack {
                    TextField("Edit Workout", text: $WorkoutVM.workout.title)
                        .font(.title)
                    
//                    Picker("Workout type", selection: $WorkoutVM.workout.type) {
//                        ForEach(typeOptions, id: \.self) {
//                            Text("\($0) sets")
//                        }
//                    }
                    
                    Button(action: { showing.toggle() }) {
                        Text("Done")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke()
                            )
                    }
                    
                }
            }
            .frame(width: geo.size.width, height: geo.size.height - 200)
            .cornerRadius(25)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .shadow(radius: 10)
        }
    }
}

struct EditNumbersWindow: View {
    @ObservedObject var exerciseVM: ExerciseViewModel
    @Binding var showing: Bool
    
    let setRange: [Int] = Array(1 ..< 11)
    let repRange: [Int] = Array(1 ..< 101)
    let restTimeRange = [0, 30, 45, 60, 90, 120, 150, 180]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(UIColor.systemBackground)
                VStack {
                    Text("Edit Exercise")
                        .font(.title)
                    
                    HStack {
                        Picker("Sets", selection: $exerciseVM.exercise.sets) {
                            ForEach(setRange, id: \.self) {
                                Text("\($0) sets")
                            }
                        }
                        .frame(width: geo.size.width / 3)
                        .compositingGroup()
                        .clipped()
                        
                        Picker("Reps", selection: $exerciseVM.exercise.reps) {
                            ForEach(repRange, id: \.self) {
                                Text("\($0) reps")
                            }
                        }
                        .frame(width: geo.size.width / 3)
                        .compositingGroup()
                        .clipped()
                        
                        Picker("Rest time", selection: $exerciseVM.exercise.restTime) {
                            ForEach(restTimeRange, id: \.self) {
                                Text("\($0) s")
                            }
                        }
                        .frame(width: geo.size.width / 3)
                        .compositingGroup()
                        .clipped()
                    }
                    
                    Button(action: { showing.toggle() }) {
                        Text("Done")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke()
                            )
                    }
                    
                }
            }
            .frame(width: geo.size.width, height: geo.size.height - 200)
            .cornerRadius(25)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .shadow(radius: 10)
        }
    }
}


struct WorkoutList_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutList(WorkoutVM: createTestWorkout())
    }
}
