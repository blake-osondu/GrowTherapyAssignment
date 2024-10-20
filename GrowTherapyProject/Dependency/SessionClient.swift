//
//  SessionClient.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/20/24.
//

import Foundation
import Dependencies

struct SessionClient {
    let observeSession: @Sendable (String) async throws -> Session
    let fetchSession: @Sendable (String) async throws -> Session
    let getSession: () -> Session?
    let endSession: @Sendable (Session) async throws -> Void
    let updateSession: @Sendable (Session) async throws -> Void
}

class SessionManager {
    private var session: Session?
    static let shared = SessionManager()
    
    func getSession() -> Session? {
        session
    }
    
    func fetchSession(_ id: String) async throws -> Session {
        let session = Session(id: id,
                       timeStart: nil,
                       dateCompleted: nil,
                       duration: 0,
                       therapistId: UUID().uuidString,
                       clientId: UUID().uuidString,
                       isTherapistInSession: false)
        self.session = session
        return session
    }
    
    func observeSession(_ id: String) async throws -> Session {
        if let session = session {
            return session
        } else {
            try await Task.sleep(for: .seconds(10))
            let session = Session(id: id,
                           timeStart: nil,
                           dateCompleted: nil,
                           duration: 0,
                           therapistId: UUID().uuidString,
                           clientId: UUID().uuidString,
                           isTherapistInSession: true)
            self.session = session
            return session
        }
    }
    
    func updateSession(_ session: Session) async throws -> Void {
        
    }
    
    func endSession(_ session: Session) async throws -> Void {
        
    }
}

extension SessionClient: DependencyKey {
    static var liveValue: SessionClient = .init(
        observeSession: { id in
            try await SessionManager.shared.observeSession(id)
        }, fetchSession: { id in
            try await SessionManager.shared.fetchSession(id)
        },
        getSession: {
            SessionManager.shared.getSession()
        }, endSession: { session in
            try await SessionManager.shared.endSession(session)
        }, updateSession: { session in
            try await SessionManager.shared.updateSession(session)
        })
}
extension SessionClient: TestDependencyKey {
    static var testValue: SessionClient = .init(
        observeSession: { id in
            try await SessionManager.shared.observeSession(id)
        },
        fetchSession: { id in
            try await SessionManager.shared.fetchSession(id)
        },
        getSession: {
            SessionManager.shared.getSession()
        }, endSession: { session in
            try await SessionManager.shared.endSession(session)
        }, updateSession: { session in
            try await SessionManager.shared.updateSession(session)
        })
}
extension DependencyValues {
    var sessionClient: SessionClient {
        get { self[SessionClient.self] }
        set { self[SessionClient.self] = newValue }
    }
}
