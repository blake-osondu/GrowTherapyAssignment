//
//  WaitingRoomView.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/19/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct WaitingRoomView: View {
    
    var store: StoreOf<WaitRoomFeature>
    
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            ZStack {
                if viewStore.isTherapistInSession {
                    Color.appLightPurple.edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Provider is In \n the session")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.appBlack)
                        Button(action: {viewStore.send(.didSelectJoin)}) {
                            Text("Join Now")
                                .foregroundStyle(Color.appBlack)
                                .padding()
                        }.background(
                            RoundedRectangle(cornerRadius: 8.0)
                                .fill(Color.appLightGreen)
                        )
                    }
                } else {
                    Color.appLightGreen.edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Waiting for provider...")
                            .foregroundStyle(Color.appBlack)
                            .font(.headline)
                            .padding(.bottom, 16)
                        Text("When they come online you'll be redirected to \n the session automatically")
                            .foregroundStyle(Color.appBlack)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}

#Preview("Waiting Room") {
    WaitingRoomView(store: .init(initialState: WaitRoomFeature.State(isTherapistInSession: false), reducer: {
            WaitRoomFeature()
    }))
}

