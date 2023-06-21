//
//  ContentView.swift
//  Chronos
//
//  Created by Jakob Nordhagen on 3/15/21.
//

import SwiftUI

struct Launch: View {
    @State var streakLength: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    Text("CHRONOS")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    NavigationLink(destination: WorkoutList(WorkoutVM: WorkoutViewModel())) {
                        ZStack {
                            HStack {
                                Text("New workout")
                                Image(systemName: "square.and.pencil")
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 9)
                        }
                    }
                    
                    NavigationLink(destination: History()) {
                        HStack {
                            Text("View history")
                            Image(systemName: "bookmark")
                        }
                        .padding(2)
                    }
                    
                    HStack {
                        Text("View stats")
                        Image(systemName: "chart.pie")
                    }
                    .padding(2)
                    
                    HStack {
                        Text("Settings")
                        Image(systemName: "gear")
                    }
                    .padding(2)
                    
                    // icon (mascot similar to Duo),
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Text("\(streakLength)🔥")
                    .padding()
            )
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Launch()
    }
}
