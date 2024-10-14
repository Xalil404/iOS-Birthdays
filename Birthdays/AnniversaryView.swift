//
//  AnniversaryView.swift
//  Birthdays
//
//  Created by TEST on 14.10.2024.
//

import SwiftUI
import CoreData

struct AnniversaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AnniversaryReminder.date, ascending: true)],
        animation: .default)
    private var anniversaries: FetchedResults<AnniversaryReminder>

    @State private var newName: String = ""
    @State private var newDate: Date = Date()
    @State private var showingAddAnniversary = false
    @State private var showingEditAnniversary = false
    @State private var selectedAnniversary: AnniversaryReminder?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(anniversaries) { anniversary in
                        HStack {
                            Text(anniversary.name ?? "Unnamed")
                            Spacer()
                            Text(dateFormatter.string(from: anniversary.date ?? Date()))
                        }
                        .onTapGesture {
                            // Set the selected anniversary for editing
                            selectedAnniversary = anniversary
                            newName = anniversary.name ?? ""
                            newDate = anniversary.date ?? Date()
                            showingEditAnniversary = true // Show the edit sheet
                        }
                    }
                    .onDelete(perform: deleteAnniversary)
                }
                .navigationTitle("Anniversaries")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddAnniversary = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddAnniversary) {
                    VStack {
                        Text("Add Anniversary Reminder")
                            .font(.headline)
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                            .padding()

                        Button("Add Reminder") {
                            addAnniversary()
                            showingAddAnniversary = false
                        }
                        .padding()
                    }
                    .padding()
                }
                .sheet(isPresented: $showingEditAnniversary) {
                    VStack {
                        Text("Edit Anniversary Reminder")
                            .font(.headline)
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                            .padding()

                        Button("Save Changes") {
                            if let anniversary = selectedAnniversary {
                                editAnniversary(anniversary: anniversary, newName: newName, newDate: newDate)
                                showingEditAnniversary = false
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }
        }
    }

    private func addAnniversary() {
        let newAnniversary = AnniversaryReminder(context: viewContext)
        newAnniversary.name = newName
        newAnniversary.date = newDate

        do {
            try viewContext.save()
            newName = ""
            newDate = Date()
        } catch {
            // Handle the error appropriately
            print("Error saving anniversary: \(error)")
        }
    }

    private func editAnniversary(anniversary: AnniversaryReminder, newName: String, newDate: Date) {
        anniversary.name = newName
        anniversary.date = newDate

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error editing anniversary: \(error)")
        }
    }

    private func deleteAnniversary(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(anniversaries[index])
        }

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error deleting anniversary: \(error)")
        }
    }
}


struct AnniversaryView_Previews: PreviewProvider {
    static var previews: some View {
        AnniversaryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

