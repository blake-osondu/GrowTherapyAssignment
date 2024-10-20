//
//  ExerciseView.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/19/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct ExerciseView: View {
    var store: StoreOf<ExerciseFeature>
    var body: some View {
        WithViewStore(store , observe: { $0 }) { viewstore in
            ZStack {
                Color.appLightBeige.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Breathe For")
                        .font(.largeTitle)
                        .padding(.vertical)
                    Text("\(viewstore.breathCount)")
                        .font(.system(size: 100))
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(RadialGradient(colors: [Color.appLightPurple.opacity(0.3), Color.appLightPurple.opacity(0.7),], center: .center, startRadius: 10, endRadius: 40))
                            .frame(width: 40, height: 40)
                            .scaleEffect(
                                CGSize(
                                    width: viewstore.inhale ? 10 : 1,
                                    height: viewstore.inhale ? 10 : 1))
                            .animation(.easeIn(duration: viewstore.countDown.length/2), value: viewstore.inhale)
                        Circle()
                            .fill(RadialGradient(colors: [Color.appLightPurple.opacity(0.5), Color.appLightPurple,], center: .center, startRadius: 10, endRadius: 40))
                            .frame(width: 40, height: 40)
                            .scaleEffect(CGSize(width: viewstore.inhale ? 6 : 1, height: viewstore.inhale ? 6 : 1))
                            .animation(.easeIn(duration: viewstore.countDown.length/2), value: viewstore.inhale)
                    }
                    
                    Spacer()
                    if viewstore.isTherapistInSession {
                        VStack {
                            Text("Provider is In the session")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.appBlack)
                            Button(action: {viewstore.send(.didSelectJoin)}) {
                                Text("Join Now")
                                    .foregroundStyle(Color.appBlack)
                                    .padding()
                            }.background(
                                RoundedRectangle(cornerRadius: 8.0)
                                    .fill(Color.appLightGreen)
                            )
                        }
                    }
                }
            }
            .onTapGesture {
                viewstore.send(.didToggle)
            }
        }
    }
}

#Preview("Exercise View") {
    ExerciseView(store: .init(initialState: ExerciseFeature.State(exercise: .init(breathCountRequired: 3), isTherapistInSession: true, isExerciseInProgress: false), reducer: {
            ExerciseFeature()
    }))
}

