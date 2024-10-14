//
//  OnboardingView.swift
//  Birthdays
//
//  Created by TEST on 14.10.2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0 // Track the current onboarding page
    @State private var isOnboardingCompleted = false // Track onboarding completion
    
    let onboardingData = [
        OnboardingData(imageName: "Frame 10", title: "Welcome", description: "Welcome to the app! Let's get started."),
        OnboardingData(imageName: "Frame 101", title: "Discover", description: "Find the best experiences and offers."),
        OnboardingData(imageName: "Frame 102", title: "Enjoy", description: "Enjoy the features and make the most of it.")
    ]
    
    var body: some View {
        Group {
            if isOnboardingCompleted {
                // Show the main content view after onboarding is completed
                ContentView()
            } else {
                // Onboarding content
                VStack {
                    // Onboarding content in a tab view
                    TabView(selection: $currentPage) {
                        ForEach(0..<onboardingData.count, id: \.self) { index in
                            OnboardingScreenView(data: onboardingData[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Disable default dots
                    
                    // Custom Progress Indicator (dots)
                    HStack {
                        ForEach(0..<onboardingData.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.black : Color.gray)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    Spacer() // Push the "Next" button to the bottom
                    
                    // Next Button
                    Button(action: {
                        if currentPage < onboardingData.count - 1 {
                            currentPage += 1 // Move to the next page
                        } else {
                            // Complete onboarding
                            isOnboardingCompleted = true // Trigger navigation to ContentView
                        }
                    }) {
                        Text(currentPage < onboardingData.count - 1 ? "Next" : "Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40) // Add some space at the bottom
                }
                .background(Color.white.ignoresSafeArea()) // White background and safe area handling
            }
        }
    }
}

struct OnboardingScreenView: View {
    var data: OnboardingData
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer() // Push content to the center
            
            Image(data.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250) // Adjust height to match your design
            
            Text(data.title)
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            Text(data.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40) // Adjust padding to match design
            
            Spacer() // Push the content away from the button
        }
    }
}

// Model for Onboarding Data
struct OnboardingData {
    let imageName: String
    let title: String
    let description: String
}

// Preview the onboarding flow
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
