//
//  SessionView.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/18/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct SessionView: View {
    var store: StoreOf<SessionFeature>
    
    var body: some View {
        WithViewStore(store , observe: {$0}) { viewStore in
            ZStack {
                Color.appLightGreen.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("In Session")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.appBlack)
                        .padding(.bottom, 8)
                    Button {
                        viewStore.send(.didSelectExitSession)
                    } label: {
                        Text("Exit")
                            .foregroundStyle(Color.white)
                            .padding()
                    }.background(
                        RoundedRectangle(cornerRadius: 8.0)
                            .fill(Color.black)
                    )
                }
            }.onAppear {
                viewStore.send(.onAppear)
            }
        }.fullScreenCover(store: store.scope(state: \.$moodLog, action: \.moodLog)) { store in
            MoodLogView(store: store)
        }
    }
}

#Preview("Session View") {
    SessionView(store: .init(
        initialState: SessionFeature.State(
            assignmentId: "",
            session: Session(
                id: "",
                timeStart: nil,
                dateCompleted: nil,
                duration: 0.0,
                therapistId: "",
                clientId: "",
                therapistIsInMeeting: true,
                clientIsInMeeting: true)
        ), reducer: {
            SessionFeature()
                .dependency(\.networkClient, .testValue)
    }))
}

