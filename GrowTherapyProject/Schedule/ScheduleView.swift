//
//  ScheduleView.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/18/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ScheduleView: View {
    var store: StoreOf<ScheduleFeature>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.appLightBeige.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: 20)
                    Text("My Tasks")
                        .font(.largeTitle)
                        .bold()
                    Spacer().frame(height: 40)
                    ScrollView {
                        ForEach(viewStore.assignments) { assignment in
                            AssignmentRow(
                                date: assignment.dateAssigned,
                                status: assignmentStatus(isCompleted: assignment.isCompleted, isUnlocked: assignment.isScheduleUnlocked),
                                mood: assignment.cooldown?.log) {
                                                       viewStore.send(.selectAssignment(assignment))
                                                   }
                                                   .disabled(!assignment.isScheduleUnlocked || assignment.isCompleted)
                                                   .padding(.horizontal, 16)
                                                   .padding(.vertical, 2)
                        }
                    }
                    Spacer()
                }.onAppear {
                    viewStore.send(.didAppear)
                }
            }
        }.fullScreenCover(store: store.scope(state: \.$selectedAssignment, action: \.selectedAssignment)) { store in
            AssignmentView(store: store)
        }
    }
}

struct AssignmentRow: View {
   
    let date: Date
    let status: AssignmentStatus
    let mood: Mood?
    let onSelect: () -> Void
    
    var body: some View {
        
        Button(action: onSelect, label: {
            HStack {
                Text(assignmentDateDescription(isCompleted: status == .completed, mood: mood, date))
                    .foregroundStyle(assignmentTitleColor(status))
                    .padding(.horizontal)
                Spacer()
                Image(systemName: assignmentStatusImage(status))
                    .foregroundColor(assignmentStatusColor(status))
                    .padding(.horizontal)
            }.frame(height: 55)
        })
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(Color.appBlack, lineWidth: 1.0)
        )
    }
}

#Preview("Schedule View") {
    ScheduleView(store:
            .init(
                initialState: ScheduleFeature.State(),
                reducer: {
                    ScheduleFeature()
                        .dependency(\.networkClient, .testValue)
                }))
    
}
