//
//  MoodLogView.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/19/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct MoodLogView: View {
    var store: StoreOf<MoodLogFeature>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.appLightBeige.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: 100)
                    Text("How have you \n been feeling this \n week?")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 34, weight: .bold))
                    Spacer().frame(height: 50)
                    ScrollView {
                        ForEach(Mood.allCases) { mood in
                            MoodRow(
                                mood: mood,
                                isSelected: viewStore.selectedMood == mood,
                                onSelect:{
                                    viewStore.send(.didSelectMood(mood))
                                })
                            .padding(.horizontal, 16)
                            .padding(.vertical, 2)
                        }
                        
                        Button {
                            viewStore.send(.didSelectLogActivity)
                        } label: {
                            Text("Log Activity")
                                .padding(.vertical)
                                .foregroundStyle(logActivityTitleColor(viewStore.canLogMood))
                                .frame(maxWidth: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(logActivityColor(viewStore.canLogMood))
                        )
                        .padding(.vertical, 24)
                        .padding(.horizontal)
                        .disabled(!viewStore.canLogMood)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

struct MoodRow: View {
   
    let mood: Mood
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect, label: {
            HStack {
                Text(mood.rawValue)
                    .foregroundStyle(Color.appBlack)
                    .padding(.horizontal)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.appBlack)
                        .padding(.horizontal)
                }
            }.frame(height: 55)
        })
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(isSelected ? Color.appLightPurple : Color.clear, style: FillStyle())
                .stroke(Color.appBlack, lineWidth: 1.0)
        )
    }
}


#Preview("Schedule View") {
    MoodLogView(store: .init(initialState: MoodLogFeature.State(assignmentId: ""), reducer: {
        MoodLogFeature()
            .dependency(\.networkClient, .testValue)
        
    }))
}

