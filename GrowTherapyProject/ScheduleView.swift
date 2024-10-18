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
                Color(uiColor: UIColor(red: 253/255, green: 249/255, blue: 238/255, alpha: 1.0)).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: 20)
                    Text("My Tasks")
                        .font(.largeTitle)
                        .bold()
                    Spacer().frame(height: 40)
                    ScrollView {
                        ForEach(viewStore.tasks) { task in
                            TaskRow(
                                date: task.dateAssigned,
                                status: taskStatus(isCompleted: task.isCompleted,
                                                   isUnlocked: task.isScheduleUnlocked)) {
                                                       viewStore.send(.selectTask(task))
                                                   }
                                                   .padding(.horizontal, 16)
                                                   .padding(.vertical, 2)
                        }
                    }
                    Spacer()
                }.onAppear {
                    viewStore.send(.didAppear)
                }
            }
            
        }
    }
}

struct TaskRow: View {
   
    let date: Date
    let status: TaskStatus
    let onSelect: () -> Void
    
    var body: some View {
        
        Button(action: onSelect, label: {
            HStack {
                Text(taskDateDescription(isCompleted: status == .completed, date))
                    .foregroundStyle(taskTitleColor(status))
                    .padding(.horizontal)
                Spacer()
                Image(systemName: taskStatusImage(status))
                    .foregroundColor(taskStatusColor(status))
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
                    ScheduleFeature().dependency(\.networkClient, .testValue)
                }))
    
}

#warning("Should the task be locked if it was scheduled in the past and was not completed. Should it even appear if it was in the past and not completed")
