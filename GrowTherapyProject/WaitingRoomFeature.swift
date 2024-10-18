//
//  WaitingRoomFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WaitRoomFeature {
    
    @ObservableState
    struct State: Equatable {
    
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some Reducer<State,Action> {
        Reduce { state, action in
            return .none
        }
    }
}
