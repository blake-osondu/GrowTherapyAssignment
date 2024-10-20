//
//  Models.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/18/24.
//

import Foundation


enum AssignmentStatus {
    case completed
    case notCompleted
    case notAvailable
}

struct Assignment: Equatable, Codable, Identifiable {
    var id: String
    var dateAssigned: Date
    var exercise: Breathwork
    var sessionId: String
    var cooldown: MoodLog?
    var isCompleted: Bool = false
    var isScheduleUnlocked: Bool {
        Calendar.current.date(dateAssigned, matchesComponents: Calendar.current.dateComponents([.day, .month, .year], from: Date()))
    }
    
    init(id: String, dateAssigned: Date, exercise: Breathwork, sessionId: String, cooldown: MoodLog? = nil, isCompleted: Bool = false) {
        self.id = id
        self.dateAssigned = dateAssigned
        self.exercise = exercise
        self.sessionId = sessionId
        self.cooldown = cooldown
        self.isCompleted = isCompleted
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let timestamp = try container.decode(TimeInterval.self, forKey: .dateAssigned)
        self.dateAssigned = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + (3600 * 24 * timestamp))
        self.exercise = try container.decode(Breathwork.self, forKey: .exercise)
        self.sessionId = try container.decode(String.self, forKey: .sessionId)
        self.cooldown = try container.decodeIfPresent(MoodLog.self, forKey: .cooldown)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
}

struct Breathwork: Equatable, Codable {
    var isCompleted: Bool
    var breathCountRequired: Int
    
    init(isCompleted: Bool = false, breathCountRequired: Int) {
        self.isCompleted = isCompleted
        self.breathCountRequired = breathCountRequired
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.breathCountRequired = try container.decode(Int.self, forKey: .breathCountRequired)
    }
}

enum Mood: String, Equatable, Codable, CaseIterable, Identifiable {
    case happy, sad, content, angry, frustrated
    var id: String {
        rawValue
    }
}

struct MoodLog: Equatable, Codable {
    var isCompleted: Bool
    var log: Mood?
    
    init(isCompleted: Bool = false, log: Mood? = nil) {
        self.isCompleted = isCompleted
        self.log = log
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.log = try container.decodeIfPresent(Mood.self, forKey: .log)
    }
}

struct Session: Codable, Equatable, Identifiable {
    var id: String
    var timeStart: Date?
    var dateCompleted: Date?
    var duration: TimeInterval = 0
    var therapistId: String
    var clientId: String
    var isTherapistInSession: Bool = false
    
    init(id: String, timeStart: Date? = nil, dateCompleted: Date? = nil, duration: TimeInterval = 0, therapistId: String, clientId: String, isTherapistInSession: Bool = false) {
        self.id = id
        self.timeStart = timeStart
        self.dateCompleted = dateCompleted
        self.duration = duration
        self.therapistId = therapistId
        self.clientId = clientId
        self.isTherapistInSession = isTherapistInSession
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let timestampStart = try? container.decodeIfPresent(TimeInterval.self, forKey: .timeStart)
        if let timestampStart = timestampStart {
            self.dateCompleted = Date(timeIntervalSince1970: timestampStart)
        }
        let timestamp = try? container.decodeIfPresent(TimeInterval.self, forKey: .dateCompleted)
        if let timestamp = timestamp {
            self.dateCompleted = Date(timeIntervalSince1970: timestamp)
        }
        self.duration = try container.decode(TimeInterval.self, forKey: .duration)
        self.therapistId = try container.decode(String.self, forKey: .therapistId)
        self.clientId = try container.decode(String.self, forKey: .clientId)
        self.isTherapistInSession = try container.decode(Bool.self, forKey: .isTherapistInSession)
    }
}

struct TasksReponse: Codable {
    var tasks: [Assignment]
}
