//
//  Utilities.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/18/24.
//

import Foundation
import SwiftUI

func assignmentStatus(isCompleted: Bool, isUnlocked: Bool) -> AssignmentStatus {
    switch (isCompleted, isUnlocked) {
    case (true, _):
        return .completed
    case (false, false):
        return .notAvailable
    case (false, true):
        return .notCompleted
    }
}

func assignmentStatusImage(_ status: AssignmentStatus) -> String {
    switch status {
    case .completed:
        return "checkmark.seal.fill"
    case .notCompleted:
        return "chevron.right"
    case .notAvailable:
        return "lock"
    }
}

func assignmentDateDescription( isCompleted: Bool, mood: Mood?, _ date: Date) -> String {
    let components = Calendar.current.dateComponents([.month, .day], from: date)

    if let monthIndex = components.month, let day = components.day {
        let month = Calendar.current.monthSymbols[monthIndex-1]
        let dateDescription = "\(month) \(day)"
        if isCompleted, let mood = mood {
            return "\(mood.rawValue.capitalized) (\(dateDescription))"
        } else {
            return dateDescription
        }
    }
    return date.description
}

func assignmentStatusColor(_ status: AssignmentStatus) -> Color {
    switch status {
    case .completed:
        return Color.appLightPurple
    case .notAvailable:
        return Color.appLightGray
    case .notCompleted:
        return Color.appBlack
    }
}

func logActivityTitleColor(_ isEnabled: Bool) -> Color {
    isEnabled ? Color.appBlack : Color.appExtraLightGray
}

func logActivityColor(_ isEnabled: Bool) -> Color {
    isEnabled ? Color.appLightGreen : Color.appUltraLightGray
}

extension Color {
    static let appLightPurple = Color(uiColor: UIColor(red: 189/255, green: 177/255, blue: 250/255, alpha: 1))
    static let appLightGray = Color(uiColor: UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1))
    static let appUltraLightGray = Color(uiColor: UIColor(red: 120/255, green: 120/255, blue: 128/255, alpha: 0.12))
    static let appExtraLightGray = Color(uiColor: UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3))
    static let appBlack = Color(uiColor: UIColor(red: 51/255, green: 56/255, blue: 52/255, alpha: 1))
    static let appLightGreen = Color(uiColor: UIColor(red: 215/255, green: 240/255, blue: 190/255, alpha: 1))
    static let appLightBeige =  Color(uiColor: UIColor(red: 253/255, green: 249/255, blue: 238/255, alpha: 1.0))
    
}

func assignmentTitleColor(_ status: AssignmentStatus) -> Color {
    status == .notAvailable ? Color.appLightGray : Color.appBlack
}
