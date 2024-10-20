//
//  SessionFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct SessionFeature {
    
    @ObservableState
    struct State: Equatable {
        var assignmentId: String
        var session: Session
        var duration: TimeInterval = 0
        var sessionIsInProgress: Bool = false
        @Presents var moodLog: MoodLogFeature.State?
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.networkClient) var networkClient
    
    enum Action: Equatable {
        case onAppear
        case beginSession
        case didSelectExitSession
        case timerTicked
        case endSession
        case logMood
        case moodLog(PresentationAction<MoodLogFeature.Action>)
    }
    
    
    var body: some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.sessionIsInProgress = true
                return .send(.beginSession)
                
            case .beginSession:
                guard state.sessionIsInProgress else { return .none }
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                
            case .timerTicked:
                guard state.sessionIsInProgress else { return .none }
                state.duration = state.duration + 1
                return .none
                
            case .didSelectExitSession:
                state.sessionIsInProgress = false
                state.session.duration = state.duration
                let finalSession = state.session
                return .run { send in
                    do {
                        _ = try await networkClient.endSession(finalSession)
                        await send(.logMood)
                    } catch {
                        await send(.logMood)
                    }
                }
                
            case .logMood:
                state.moodLog = MoodLogFeature.State(assignmentId: state.assignmentId)
                return .none
                
            case .moodLog(.presented(.completedSaveMood)):
                return .send(.endSession)
                
            case .endSession:
                return .none
                
            case .moodLog:
                return .none
            }
            
        }.ifLet(\.$moodLog, action: \.moodLog) {
            MoodLogFeature()
                .dependency(\.networkClient, .testValue)
        }
    }
}
