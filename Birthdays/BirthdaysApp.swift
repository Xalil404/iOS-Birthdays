//
//  BirthdaysApp.swift
//  Birthdays
//
//  Created by TEST on 14.10.2024.
//

import SwiftUI

@main
struct BirthdaysApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            // Show OnboardingView every time
            OnboardingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}



