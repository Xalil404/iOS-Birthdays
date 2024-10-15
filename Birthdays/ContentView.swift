//
//  ContentView.swift
//  Birthdays
//
//  Created by TEST on 14.10.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BirthdayReminder.date, ascending: true)],
        animation: .default)
    private var reminders: FetchedResults<BirthdayReminder>

    @State private var newName: String = ""
    @State private var newDate: Date = Date()
    @State private var showingAddReminder = false
    @State private var showingEditReminder = false
    @State private var selectedReminder: BirthdayReminder?

    var body: some View {
        TabView {
            BDayView()
                .tabItem {
                    Image(systemName: "birthday.cake")
                    Text("B-Day")
                }

            AnniversaryView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Anniversary")
                }

            MomentsView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Moment")
                }
        }
        .accentColor(.white) // Customize the accent color for the selected tab
        .onAppear {
            // Set the background color of the Tab Bar
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor.systemBlue // Choose your color here
            // Set the colors for selected and unselected items
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.black // Unselected icon color
            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white // Selected icon color
            // Set the colors for unselected and selected text
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black] // Unselected text color
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white] // Selected text color
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        
    }
}

struct BDayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BirthdayReminder.date, ascending: true)],
        animation: .default)
    private var reminders: FetchedResults<BirthdayReminder>

    @State private var newName: String = ""
    @State private var newDate: Date = Date()
    @State private var showingAddReminder = false
    @State private var showingEditReminder = false
    @State private var selectedReminder: BirthdayReminder?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(reminders) { reminder in
                        HStack {
                            Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                            .padding()
                            Text(reminder.name ?? "Unnamed")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            
                            Text(dateFormatter.string(from: reminder.date ?? Date()))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .onTapGesture {
                            // Set the selected reminder for editing
                            selectedReminder = reminder
                            newName = reminder.name ?? ""
                            newDate = reminder.date ?? Date()
                            showingEditReminder = true // Show the edit sheet
                        }
                    }
                    .onDelete(perform: deleteReminder)
                }
                
                .toolbar {
                    Group {
                        ToolbarItem(placement: .principal) { // Centers the title
                            Text("Birthdays")
                                .font(.largeTitle) // Customize the font size here
                                .bold() // Optionally make it bold
                                
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddReminder = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                                .padding(10)
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .shadow(radius: 6)
                        }
                    }
                }
                
                .sheet(isPresented: $showingAddReminder) {
                    VStack {
                        Text("Add Birthday Reminder")
                            .font(.title2)
                            .fontWeight(.bold)
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()

                        Group {
                            Button(action: {
                                addReminder()
                                showingAddReminder = false
                            }) {
                                Text("Add Reminder")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .sheet(isPresented: $showingEditReminder) {
                    VStack {
                        Text("Edit Birthday Reminder")
                            .font(.title2)
                            .fontWeight(.bold)
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()

                        Group {
                            Button(action: {
                                if let reminder = selectedReminder {
                                    editReminder(reminder: reminder, newName: newName, newDate: newDate)
                                    showingEditReminder = false
                                }
                            }) {
                                Text("Save Changes")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
        }
    }

    private func addReminder() {
        let newReminder = BirthdayReminder(context: viewContext)
        newReminder.name = newName
        newReminder.date = newDate

        do {
            try viewContext.save()
            newName = ""
            newDate = Date()
        } catch {
            // Handle the error appropriately
            print("Error saving reminder: \(error)")
        }
    }

    private func editReminder(reminder: BirthdayReminder, newName: String, newDate: Date) {
        reminder.name = newName
        reminder.date = newDate

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error editing reminder: \(error)")
        }
    }

    private func deleteReminder(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(reminders[index])
        }

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error deleting reminder: \(error)")
        }
    }
}





// Date Formatter for displaying the date
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

