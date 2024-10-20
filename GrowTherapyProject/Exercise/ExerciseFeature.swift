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
        
        init(exercise: Breathwork = .init(breathCountRequired: 0), isTherapistInSession: Bool = false, isExerciseInProgress: Bool = false) {
            self.exercise = exercise
            self.isTherapistInSession = isTherapistInSession
            self.isExerciseInProgress = isExerciseInProgress
            self.breathCount = exercise.breathCountRequired
            self.countDown = .init(length: 10)
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
                guard state.isExerciseInProgress else { 
                    
                    return .none
                }
                state.inhale.toggle()
                let halfCount = state.countDown.length / 2
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(halfCount)) {
                        await send(.timerTicked)
                    }
                }
                
            case .timerTicked:
                guard state.isExerciseInProgress else { return .none }
                state.inhale.toggle()
                if state.inhale {
                    state.breathCount = max(0, state.breathCount - 1)
                    if state.breathCount == 0 {
                        return .send(.exerciseComplete).animation(.linear(duration: 1.0))
                    }
                }
                
                
                return .none
                
            case .exerciseComplete:
                state.countDown.now = state.countDown.length
                state.breathCount = state.exercise.breathCountRequired
                state.exercise.isCompleted = true
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
