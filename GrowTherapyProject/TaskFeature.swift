//
//  AssignmentFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AssignmentFeature {
    @ObservableState
    struct State: Equatable {
        var assignment: Assignment
        @Presents var exercise: ExerciseFeature.State?
        @Presents var waitroom: WaitRoomFeature.State?
        @Presents var session: SessionFeature.State?
    }
    
    enum Action: Equatable {
        case exercise(PresentationAction<ExerciseFeature.Action>)
        case waitroom(PresentationAction<WaitRoomFeature.Action>)
        case session(PresentationAction<SessionFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .exercise(.presented(.joinTherapist(let exercise))):
                state.assignment.exercise = exercise
                state.exercise = nil
                state.session = SessionFeature.State()
                return .none
                
            case .exercise(.presented(.waitForTherapist(let exercise))):
                state.assignment.exercise = exercise
                state.exercise = nil
                state.waitroom = WaitRoomFeature.State()
                return .none
                
            default:
                return .none
            }
        }.ifLet(\.$exercise, action: \.exercise) {
            ExerciseFeature()
        }
        .ifLet(\.$waitroom, action: \.waitroom) {
            WaitRoomFeature()
        }
        .ifLet(\.$session, action: \.session) {
            SessionFeature()
        }
    }
}
