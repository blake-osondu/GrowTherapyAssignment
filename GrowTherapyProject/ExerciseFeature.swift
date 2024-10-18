//
//  ExerciseFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import Combine

@Reducer
struct ExerciseFeature {
    
    struct CountDown: Equatable {
        let length: Double
        var now: Double
        
        init(length: Double) {
            self.length = length
            self.now = length
        }
    }
    
    @ObservableState
    struct State: Equatable {
        var exercise: Breathwork
        var isTherapistInSession: Bool
        var isExerciseInProgress: Bool
        var breathCount: Int
        var countDown: CountDown
        var inhale: Bool = false
        
        init(exercise: Breathwork, isTherapistInSession: Bool, isExerciseInProgress: Bool) {
            self.exercise = exercise
            self.isTherapistInSession = isTherapistInSession
            self.isExerciseInProgress = isExerciseInProgress
            self.breathCount = exercise.breathCountRequired
            self.countDown = .init(length: 3)
        }
    }
    
    @Dependency(\.continuousClock) var clock
    
    enum Action: Equatable {
        case timerTicked
        case didToggle
        case exerciseComplete
        case waitForTherapist(Breathwork)
        case didSelectJoin
        case joinTherapist(Breathwork)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .didToggle:
                state.isExerciseInProgress.toggle()
                guard state.isExerciseInProgress else { return .none }
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                
            case .timerTicked:
                guard state.isExerciseInProgress else { return .none }
                
                state.countDown.now = max(0, state.countDown.now - 1)

                if state.countDown.now == 0 {
                    state.breathCount = max(0, state.breathCount - 1)
                    if state.breathCount == 0 {
                        return .send(.exerciseComplete).animation(.linear(duration: 1.0))
                    } else {
                        state.countDown.now = state.countDown.length
                    }
                }
                
                state.inhale = state.countDown.now <= state.countDown.length/2
                return .none
                
            case .exerciseComplete:
                state.countDown.now = state.countDown.length
                state.breathCount = state.exercise.breathCountRequired
                state.exercise.dateCompleted = Date()
                state.isExerciseInProgress = false
                state.inhale = false
                return .send(.waitForTherapist(state.exercise))
                
            case .didSelectJoin:
                return .send(.joinTherapist(state.exercise))
                
            default:
                return .none
            }
        }
    }
}


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
                            .onTapGesture {
                                viewstore.send(.didToggle)
                            }
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
        }
    }
}

#Preview("Exercise View") {
    ExerciseView(store: .init(initialState: ExerciseFeature.State(exercise: .init(breathCountRequired: 3), isTherapistInSession: true, isExerciseInProgress: false), reducer: {
            ExerciseFeature()
    }))
}
