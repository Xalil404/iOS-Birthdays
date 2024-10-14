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
        .accentColor(.black) // Customize the accent color for the selected tab
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
                            Text(reminder.name ?? "Unnamed")
                            Spacer()
                            Text(dateFormatter.string(from: reminder.date ?? Date()))
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
                .navigationTitle("Birthdays")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddReminder = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddReminder) {
                    VStack {
                        Text("Add Birthday Reminder")
                            .font(.headline)
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                            .padding()

                        Button("Add Reminder") {
                            addReminder()
                            showingAddReminder = false
                        }
                        .padding()
                    }
                    .padding()
                }
                .sheet(isPresented: $showingEditReminder) {
                    VStack {
                        Text("Edit Birthday Reminder")
                            .font(.headline)
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                            .padding()

                        Button("Save Changes") {
                            if let reminder = selectedReminder {
                                editReminder(reminder: reminder, newName: newName, newDate: newDate)
                                showingEditReminder = false
                            }
                        }
                        .padding()
                    }
                    .padding()
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

