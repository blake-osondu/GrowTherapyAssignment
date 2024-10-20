//
//  AssignmentFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct AssignmentFeature {
    @ObservableState
    struct State: Equatable {
        var assignment: Assignment
        var phase: AssignmentPhase = .exercise
        var exercise: ExerciseFeature.State = .init(exercise: .init(breathCountRequired: 0), isTherapistInSession: false)
        var waitroom: WaitRoomFeature.State = .init(sessionId: "", isTherapistInSession: false)
        var session: SessionFeature.State = .init(assignmentId: "", session: Session(id: "", therapistId: "", clientId: ""))
        
        enum AssignmentPhase: Equatable {
            case exercise, waitroom, session
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case completedAssignment(Assignment)
        case failedToStoreCompletedAssignment
        case exercise(ExerciseFeature.Action)
        case waitroom(WaitRoomFeature.Action)
        case session(SessionFeature.Action)
    }
    
    @Dependency(\.networkClient) var networkClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.exercise = ExerciseFeature.State(exercise: state.assignment.exercise,
                                                       isTherapistInSession: state.assignment.session.therapistIsInMeeting)
                state.phase = .exercise
                return .none
            
            case .exercise(.joinTherapist(let exercise)):
                state.assignment.exercise = exercise
                state.session = SessionFeature.State(assignmentId: state.assignment.id, session: state.assignment.session)
                state.phase = .session
                return .none
                
            case .exercise(.waitForTherapist(let exercise)):
                state.assignment.exercise = exercise
                state.waitroom = WaitRoomFeature.State(
                    sessionId: state.assignment.session.id,
                    isTherapistInSession: state.assignment.session.therapistIsInMeeting)
                state.phase = .waitroom
                return .none
                
            case .waitroom(.willJoinTherapist):
                state.session = SessionFeature.State(assignmentId: state.assignment.id, session: state.assignment.session)
                state.phase = .session
                return .none
            
            case .session(.endSession):
                let assignment = state.assignment
                return .run { send in
                    do {
                        let assignment = try await networkClient.completeAssignment(assignment)
                        await send(.completedAssignment(assignment))
                    } catch {
                        await send(.failedToStoreCompletedAssignment)
                    }
                }
                
            default:
                return .none
            }
        }
        
        Scope(state: \.exercise, action: \.exercise) {
            ExerciseFeature()
        }
        
        Scope(state: \.waitroom, action: \.waitroom) {
            WaitRoomFeature().dependency(\.networkClient, .testValue)
        }
        
        Scope(state: \.session, action: \.session) {
            SessionFeature().dependency(\.networkClient, .testValue)
        }
    }
}
