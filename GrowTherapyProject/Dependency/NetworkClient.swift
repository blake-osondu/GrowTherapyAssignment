//
//  NetworkClient.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import Dependencies


struct NetworkClient {
    let fetchAssignments: @Sendable () async throws -> [Assignment]
    let completeAssignment: @Sendable (Assignment) async throws -> Assignment
    let saveMood: @Sendable (String, Mood) async throws -> Void
}

extension NetworkClient: DependencyKey {
    static var liveValue: NetworkClient = NetworkClient(
        fetchAssignments: {
            let decoder = JSONDecoder()
              guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json") else { return [] }
            do {
                let data = try Data(contentsOf: url)
                let response = try decoder.decode(TasksReponse.self, from: data)
                return response.tasks
            } catch {
                return []
            }
        }, completeAssignment: { assignment in
            //Use URLSession to send assignment
            Assignment(
                id: assignment.id,
                dateAssigned: assignment.dateAssigned,
                exercise: assignment.exercise,
                sessionId: assignment.sessionId,
                cooldown: assignment.cooldown,
                isCompleted: true)
        }, saveMood: { assignmentId, mood in
            //Use URLSession to log mood on assignment
        })
}

extension NetworkClient: TestDependencyKey {
    static var testValue: NetworkClient = NetworkClient(fetchAssignments: {
        return [
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 5),
                 exercise: .init(breathCountRequired: 3),
                 sessionId: UUID().uuidString),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 4),
                 exercise: .init(breathCountRequired: 6),
                 sessionId: UUID().uuidString),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 3),
                 exercise: .init(breathCountRequired: 9),
                 sessionId: UUID().uuidString),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 2),
                 exercise: .init(breathCountRequired: 12),
                 sessionId: UUID().uuidString),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 1),
                 exercise: .init(breathCountRequired: 12),
                 sessionId: UUID().uuidString),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date(),
                 exercise: .init(breathCountRequired: 3),
                 sessionId: UUID().uuidString),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -1),
                 exercise: .init(breathCountRequired: 12),
                 sessionId: UUID().uuidString,
                cooldown: .init(isCompleted: true, log: .happy),
                 isCompleted: true),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -2),
                 exercise: .init(breathCountRequired: 12),
                 sessionId: UUID().uuidString,
                       cooldown: .init(isCompleted: true, log: .content),
                 isCompleted: true),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -3),
                 exercise: .init(breathCountRequired: 12),
                 sessionId: UUID().uuidString,
                       cooldown: .init(isCompleted: true, log: .frustrated),
                 isCompleted: true)
            
        ]
    }, completeAssignment: { assignment in
        Assignment(
            id: assignment.id,
            dateAssigned: assignment.dateAssigned,
            exercise: assignment.exercise,
            sessionId: assignment.sessionId,
            cooldown: assignment.cooldown,
            isCompleted: true)
    }, saveMood: { assignmentId, mood in
        //Throw error if desired for testing
    })
}

extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
