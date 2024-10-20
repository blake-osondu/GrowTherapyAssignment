//
//  WaitingRoomFeature.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct WaitRoomFeature {
    
    @ObservableState
    struct State: Equatable {
        var isTherapistInSession: Bool = false
    }
    
    enum Action: Equatable {
        case didSelectJoin
    }
        
    var body: some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .didSelectJoin:
                return .none
            }
        }
    }
}
