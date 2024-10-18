//
//  NetworkClient.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import Foundation
import Dependencies


struct NetworkClient {
    let fetchTasks: @Sendable () async throws -> [Task]
}


extension NetworkClient: DependencyKey {
    static var liveValue: NetworkClient = NetworkClient(
        fetchTasks: {
            //Use URLSession to fetch tasks
            return []
    })
}

extension NetworkClient: TestDependencyKey {
    static var isTestValueSuccess: Bool = true
    static var testValue: NetworkClient = NetworkClient(fetchTasks: {
        guard isTestValueSuccess else {
            throw NSError()
        }
        return [
            Task(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 5),
                 exercise: .init(breathCountRequired: 3),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Task(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 4),
                 exercise: .init(breathCountRequired: 6),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Task(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 3),
                 exercise: .init(breathCountRequired: 9),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Task(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 2),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Task(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * 1),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Task(id: UUID().uuidString,
                 dateAssigned: Date(),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString)),
            Task(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -1),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString),
                 isCompleted: true),
            Task(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -2),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString),
                 isCompleted: true),
            Task(id: UUID().uuidString,
                 dateAssigned: Date().addingTimeInterval(3600 * 24 * -3),
                 exercise: .init(breathCountRequired: 12),
                 session: .init(id: UUID().uuidString,
                                therapistId: UUID().uuidString,
                                clientId: UUID().uuidString),
                 isCompleted: true)
            
        ]
    })
}

extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
