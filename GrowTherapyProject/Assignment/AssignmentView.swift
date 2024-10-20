//
//  AssignmentView.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/18/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI


struct AssignmentView: View {
    var store: StoreOf<AssignmentFeature>
    
    var body: some View {
        WithViewStore(store, observe: {$0 }) { viewStore in
            ZStack {
                switch viewStore.phase {
                case .exercise:
                    ExerciseView(store: store.scope(state: \.exercise, action: \.exercise))
                case .waitroom:
                    WaitingRoomView(store: store.scope(state: \.waitroom, action: \.waitroom))
                case .session:
                    SessionView(store: store.scope(state: \.session, action: \.session))
                }
            }.onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
}


#Preview("Assignment View") {
    AssignmentView(
        store: .init(
            initialState: AssignmentFeature.State(
                assignment: Assignment(id: "",
                                       dateAssigned: Date(),
                                       exercise: .init(breathCountRequired: 10),
                                       session: Session(id: "",
                                                        therapistId: "",
                                                        clientId: "", therapistIsInMeeting: true),
                                       cooldown: nil,
                                       isCompleted: false)),
            reducer: {
                AssignmentFeature()
            })
    )
}
