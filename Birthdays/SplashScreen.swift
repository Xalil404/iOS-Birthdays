//
//  SplashScreen.swift
//  Birthdays
//
//  Created by TEST on 15.10.2024.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            // Background color for the entire screen
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Add your logo or image here
                Image("splash") // Replace with your image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350) // Adjust the size as needed
                    .padding()
                
                Text("Welcome to Birthdays")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black) // Customize color
            }
            .background(Color.clear) // Set the background color for the splash screen
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    // Preview Provider for SplashScreen
    struct SplashScreen_Previews: PreviewProvider {
        static var previews: some View {
            SplashScreen()
                .previewDevice("iPhone 14") // You can change this to other devices as needed
        }
    }
}
