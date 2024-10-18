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
    var session: Session
    var cooldown: MoodLog?
    var isCompleted: Bool = false
    var isScheduleUnlocked: Bool {
        Calendar.current.date(dateAssigned, matchesComponents: Calendar.current.dateComponents([.day, .month, .year], from: Date()))
    }
}

struct Breathwork: Equatable, Codable {
    var dateCompleted: Date?
    var breathCountRequired: Int
}

enum Mood: Equatable, Codable {
    case happy, sad, content, angry, frustrated
}

struct MoodLog: Equatable, Codable {
    var dateCompleted: Bool?
    var log: Mood?
}

struct Session: Codable, Equatable, Identifiable {
    var id: String
    var timeStart: Date?
    var dateCompleted: Date?
    var duration: TimeInterval = 0
    var therapistId: String
    var clientId: String
    var therapistIsInMeeting: Bool = false
    var clientIsInMeeting: Bool = false
}
