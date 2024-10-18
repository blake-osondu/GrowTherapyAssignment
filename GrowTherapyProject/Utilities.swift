//
//  Utilities.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/18/24.
//

import Foundation
import SwiftUI

func taskStatus(isCompleted: Bool, isUnlocked: Bool) -> TaskStatus {
    switch (isCompleted, isUnlocked) {
    case (true, _):
        return .completed
    case (_, false):
        return .notAvailable
    case (false, true):
        return .notCompleted
    }
}

func taskStatusImage(_ status: TaskStatus) -> String {
    switch status {
    case .completed:
        return "checkmark.seal.fill"
    case .notCompleted:
        return "chevron.right"
    case .notAvailable:
        return "lock"
    }
}

func taskDateDescription( isCompleted: Bool, _ date: Date) -> String {
    let components = Calendar.current.dateComponents([.month, .day], from: date)

    if let monthIndex = components.month, let day = components.day {
        let month = Calendar.current.monthSymbols[monthIndex]
        let dateDescription = "\(month) \(day)"
        if isCompleted {
            return "Completed (\(dateDescription))"
        } else {
            return dateDescription
        }
    }
    return date.description
}

func taskStatusColor(_ status: TaskStatus) -> Color {
    switch status {
    case .completed:
        return Color.appLightPurple
    case .notAvailable:
        return Color.appLightGray
    case .notCompleted:
        return Color.appBlack
    }
}

extension Color {
    static let appLightPurple = Color(uiColor: UIColor(red: 189/255, green: 177/255, blue: 250/255, alpha: 1))
    static let appLightGray = Color(uiColor: UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1))
    static let appBlack = Color(uiColor: UIColor(red: 51/255, green: 56/255, blue: 52/255, alpha: 1))
    static let appLightGreen = Color(uiColor: UIColor(red: 215/255, green: 240/255, blue: 190/255, alpha: 1))
}

func taskTitleColor(_ status: TaskStatus) -> Color {
    status == .notAvailable ? Color.appLightGray : Color.appBlack
}
