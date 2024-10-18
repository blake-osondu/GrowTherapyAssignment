//
//  AppFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State: Equatable {
        var schedule = ScheduleFeature.State()
        var session = SessionFeature.State()
    }
    
    enum Action: Equatable {
        case task(ScheduleFeature.Action)
        case session(SessionFeature.Action)
    }
    
    var body: some Reducer<State,Action> {
        Reduce { state, action in
                return .none
        }
    }
}
