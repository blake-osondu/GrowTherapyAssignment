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
    let observeSession: @Sendable (String) async throws -> Session
}

extension NetworkClient: DependencyKey {
    static var liveValue: NetworkClient = NetworkClient(
        fetchAssignments: {
            //Use URLSession to fetch assignments
            return []
        }, observeSession: { sessionId in
            //Use URLSession to observe change on backend session
            
            Session(id: sessionId, therapistId: "", clientId: "", therapistIsInMeeting: true)
        })
}

extension NetworkClient: TestDependencyKey {
    static var isTestValueSuccess: Bool = true
    static var testValue: NetworkClient = NetworkClient(fetchAssignments: {
        guard isTestValueSuccess else {
            throw NSError()
        }
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
                 exercise: .init(breathCountRequired: 12),
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
    }, observeSession:  { id in
        _ = try await Task.sleep(nanoseconds: 10000)
        return try await withCheckedThrowingContinuation { continuation in
            continuation.resume(with: .success(Session(id: "", therapistId: "", clientId: "", therapistIsInMeeting: true)))
        }
    })
}

extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
