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
        var tasks: [Task] = []
        @Presents var selectedTask: TaskFeature.State?
    }
    
    enum Action: Equatable {
        case didAppear
        case fetchTasks
        case retrievedTasks([Task])
        case failedToRetrieveTasks
        case selectTask(Task)
        case selectedTask(TaskFeature.Action)
    }
    
    @Dependency(\.networkClient) var networkClient
    
    var body: some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                return .send(.fetchTasks)
            case .fetchTasks:
                return .run { send in
                    do {
                        let tasks = try await networkClient.fetchTasks()
                        await send(.retrievedTasks(tasks))
                    } catch {
                        await send(.failedToRetrieveTasks)
                    }
                }
                
            case .retrievedTasks(let tasks):
                state.tasks = tasks
                return .none
                
            case .failedToRetrieveTasks:
                return .none
            
            case .selectTask(let task):
                state.selectedTask = TaskFeature.State(task: task)
                return .none
                
            default:
                return .none
            }
        }.ifLet(\.selectedTask, action: \.selectedTask) {
            TaskFeature()
        }
    }
}
