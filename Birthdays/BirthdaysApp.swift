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
    
    // State variable to control splash screen visibility
    @State private var isSplashActive = true

    var body: some Scene {
        WindowGroup {
            // Show splash screen initially
            if isSplashActive {
                SplashScreen()
                    .onAppear {
                        // Delay for 2 seconds before transitioning to the main content
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isSplashActive = false // Switch to the main content
                            }
                        }
                    }
            } else {
                // Show OnboardingView every time after splash screen
                OnboardingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}






