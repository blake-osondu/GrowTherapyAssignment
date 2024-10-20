//
//  MoodLogFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct MoodLogFeature {
    @ObservableState
    struct State: Equatable {
        var assignmentId: String
        var selectedMood: Mood? = nil
        var canLogMood: Bool {
            selectedMood != nil
        }
    }
    
    
    enum Action: Equatable {
        case didSelectMood(Mood)
        case didSelectLogActivity
        case saveMood(String, Mood)
        case completedSaveMood(Mood)
        case failedToSaveMood
    }
    
    @Dependency(\.networkClient) var networkClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didSelectMood(let mood):
                state.selectedMood = mood
                return .none
            case .didSelectLogActivity:
                return .send(.saveMood(state.assignmentId, state.selectedMood!))
                
            case let .saveMood(assignmentId, mood):
                return .run { send in
                    do {
                        try await networkClient.saveMood(assignmentId, mood)
                        await send(.completedSaveMood(mood))
                    } catch {
                        await send(.failedToSaveMood)
                    }
                }
            case .failedToSaveMood:
                //Should display alert
                return .none
            case .completedSaveMood:
                //Will navigate back to schedule
                return .none
            }
        }
    }
}
