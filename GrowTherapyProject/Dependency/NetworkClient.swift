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
    let observeIsTherapistInSession: @Sendable (String) async throws -> Bool
    let endSession: @Sendable (Session) async throws -> Void
    let completeAssignment: @Sendable (Assignment) async throws -> Assignment
    let saveMood: @Sendable (String, Mood) async throws -> Void
}

extension NetworkClient: DependencyKey {
    static var liveValue: NetworkClient = NetworkClient(
        fetchAssignments: {
            //Use URLSession to fetch assignments
            return []
        }, observeIsTherapistInSession: { sessionId in
            //Use URLSession to observe change on backend session
            false
        }, endSession: { _ in
            //Use URLsession to end session and update backend
        }, completeAssignment: { assignment in
            //Use URLSession to send assignment
            return assignment
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
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 4),
                 exercise: .init(breathCountRequired: 6),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 3),
                 exercise: .init(breathCountRequired: 9),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 2),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 1),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date(),
                 exercise: .init(breathCountRequired: 3),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -1),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString),
                 isCompleted: true),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -2),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString),
                 isCompleted: true),
            Assignment(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -3),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString),
                 isCompleted: true)
            
        ]
    }, observeIsTherapistInSession:  { id in
        _ = try await Task.sleep(nanoseconds: 10000)
        return try await withCheckedThrowingContinuation { continuation in
            continuation.resume(with: .success(true))
        }
    }, endSession: { _ in
        //We could throw an error for testing here
    }, completeAssignment: { assignment in
        Assignment(id: assignment.id, dateAssigned: assignment.dateAssigned, exercise: assignment.exercise, session: Session(id: assignment.session.id, therapistId: assignment.session.therapistId, clientId: assignment.session.clientId), isCompleted: true)
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
