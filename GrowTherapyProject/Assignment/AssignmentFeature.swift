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
        var exercise: ExerciseFeature.State = .init()
        var waitroom: WaitRoomFeature.State = .init()
        var session: SessionFeature.State = .init()
        
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
        case observeSession
        case failedToObserveSession
        case didFetchSession(Session)
        case joinSession(Session)
    }
    
    @Dependency(\.networkClient) var networkClient
    @Dependency(\.sessionClient) var sessionClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.exercise = ExerciseFeature.State(exercise: state.assignment.exercise)
                state.phase = .exercise
                return .send(.observeSession)
                
            case .observeSession:
                let id = state.assignment.sessionId
                return .run { send in
                    do {
                        let session = try await sessionClient.observeSession(id)
                        await send(.didFetchSession(session))
                    } catch {
                        await send(.failedToObserveSession)
                    }
                }
                
            case .didFetchSession(let session):
                switch state.phase {
                case .exercise:
                    state.exercise.isTherapistInSession = session.isTherapistInSession
                case .waitroom:
                    state.waitroom.isTherapistInSession = session.isTherapistInSession
                case .session:
                    state.session.session = session
                }
                return .none
                
            case .failedToObserveSession:
                return .none
                
            case .exercise(.joinTherapist(let exercise)):
                state.assignment.exercise = exercise
                if let session = sessionClient.getSession() {
                    state.session = SessionFeature.State(assignmentId: state.assignment.id, session: session)
                    state.phase = .session
                    return .none
                } else {
                    let id = state.assignment.sessionId
                    return .run { send in
                        do {
                            let session = try await sessionClient.fetchSession(id)
                            await send(.joinSession(session))
                        } catch {
                            await send(.failedToObserveSession)
                        }
                    }
                }
                
            case .joinSession(let session):
                state.session = SessionFeature.State(assignmentId: state.assignment.id, session: session)
                state.phase = .session
                return .none
                
            case .exercise(.waitForTherapist(let exercise)):
                state.assignment.exercise = exercise
                state.waitroom = WaitRoomFeature.State(isTherapistInSession: sessionClient.getSession()?.isTherapistInSession ?? false)
                state.phase = .waitroom
                return .none
               
            case .waitroom(.didSelectJoin):
                if let session = sessionClient.getSession() {
                    state.session = SessionFeature.State(assignmentId: state.assignment.id, session: session)
                    state.phase = .session
                    return .none
                    
                } else {
                    let id = state.assignment.sessionId
                    return .run { send in
                        do {
                            let session = try await sessionClient.fetchSession(id)
                            await send(.joinSession(session))
                        } catch {
                            await send(.failedToObserveSession)
                        }
                    }
                }
            
            case .session(.endSession):
                //Here we would actually perform a refresh of tasks to get updated status for latest assignments if any
                
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
            WaitRoomFeature()
        }
        
        Scope(state: \.session, action: \.session) {
            SessionFeature()
                .dependency(\.sessionClient, .liveValue)
        }
    }
}
