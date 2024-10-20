//
//  GrowTherapyProjectApp.swift
//  GrowTherapyProject
//
//  Created by Blake Osonduagwueki on 10/17/24.
//

import SwiftUI

@main
struct GrowTherapyProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ScheduleView(store: .init(initialState: ScheduleFeature.State(), reducer: {
                ScheduleFeature().dependency(\.networkClient, .liveValue)
            }))
        }
    }
}
