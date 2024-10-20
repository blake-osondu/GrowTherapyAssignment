//
//  ScheduleFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct ScheduleFeature {
    
    @ObservableState
    struct State: Equatable {
        var assignments: [Assignment] = []
        @Presents var selectedAssignment: AssignmentFeature.State?
    }
    
    enum Action: Equatable {
        case didAppear
        case fetchAssignments
        case retrievedAssignments([Assignment])
        case failedToRetrieveAssignments
        case selectAssignment(Assignment)
        case selectedAssignment(PresentationAction<AssignmentFeature.Action>)
    }
    
    @Dependency(\.networkClient) var networkClient
    
    var body: some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                return .send(.fetchAssignments)
            
            case .fetchAssignments:
                return .run { send in
                    do {
                        let assignments = try await networkClient.fetchAssignments()
                        await send(.retrievedAssignments(assignments))
                    } catch {
                        await send(.failedToRetrieveAssignments)
                    }
                }
                
            case .retrievedAssignments(let assignments):
                state.assignments = assignments
                return .none
                
            case .failedToRetrieveAssignments:
                return .none
            
            case .selectAssignment(let assignment):
                state.selectedAssignment = AssignmentFeature.State(assignment: assignment)
                return .none
                
            case .selectedAssignment(.presented(.completedAssignment(let updatedAssignment))):
                state.selectedAssignment = nil
                state.assignments = state.assignments.map { assignment in
                    assignment.id == updatedAssignment.id ? updatedAssignment : assignment
                }
                return .none
                
            default:
                return .none
            }
        }.ifLet(\.$selectedAssignment, action: \.selectedAssignment) {
            AssignmentFeature()
                .dependency(\.networkClient, .testValue)
        }
    }
}
