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
        var sessionId: String
        var isTherapistInSession: Bool
    }
    
    enum Action: Equatable {
        case onAppear
        case observeSession
        case didSelectJoin
        case willJoinTherapist
        case canJoinTherapist(Bool)
        case failedToObserveSession
    }
    
    @Dependency(\.networkClient) var networkClient
    
    var body: some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.observeSession)
                
            case .observeSession:
                let id = state.sessionId
                return .run { send in
                    do {
                        let isTherapistAvailable = try await networkClient.observeIsTherapistInSession(id)
                        await send(.canJoinTherapist(isTherapistAvailable))
                    } catch {
                        await send(.failedToObserveSession)
                    }
                }
            case .canJoinTherapist(let isAvailable):
                state.isTherapistInSession = isAvailable
                return .none
                
            case .didSelectJoin:
                return .send(.willJoinTherapist)
                
            default:
                return .none
            }
        }
    }
}
