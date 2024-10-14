//
//  MomentsView.swift
//  Birthdays
//
//  Created by TEST on 14.10.2024.
//

import SwiftUI
import CoreData

struct MomentsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Moment.date, ascending: true)],
        animation: .default)
    private var moments: FetchedResults<Moment>

    @State private var newName: String = ""
    @State private var newDate: Date = Date()
    @State private var showingAddMoment = false
    @State private var showingEditMoment = false
    @State private var selectedMoment: Moment?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(moments) { moment in
                        HStack {
                            Text(moment.name ?? "Unnamed")
                            Spacer()
                            Text(dateFormatter.string(from: moment.date ?? Date()))
                        }
                        .onTapGesture {
                            // Set the selected moment for editing
                            selectedMoment = moment
                            newName = moment.name ?? ""
                            newDate = moment.date ?? Date()
                            showingEditMoment = true // Show the edit sheet
                        }
                    }
                    .onDelete(perform: deleteMoment)
                }
                .navigationTitle("Moments")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddMoment = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddMoment) {
                    VStack {
                        Text("Add Moment")
                            .font(.headline)
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                            .padding()

                        Button("Add Moment") {
                            addMoment()
                            showingAddMoment = false
                        }
                        .padding()
                    }
                    .padding()
                }
                .sheet(isPresented: $showingEditMoment) {
                    VStack {
                        Text("Edit Moment")
                            .font(.headline)
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                            .padding()

                        Button("Save Changes") {
                            if let moment = selectedMoment {
                                editMoment(moment: moment, newName: newName, newDate: newDate)
                                showingEditMoment = false
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }
        }
    }

    private func addMoment() {
        let newMoment = Moment(context: viewContext)
        newMoment.name = newName
        newMoment.date = newDate

        do {
            try viewContext.save()
            newName = ""
            newDate = Date()
        } catch {
            // Handle the error appropriately
            print("Error saving moment: \(error)")
        }
    }

    private func editMoment(moment: Moment, newName: String, newDate: Date) {
        moment.name = newName
        moment.date = newDate

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error editing moment: \(error)")
        }
    }

    private func deleteMoment(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(moments[index])
        }

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error deleting moment: \(error)")
        }
    }
}

struct MomentsView_Previews: PreviewProvider {
    static var previews: some View {
        MomentsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

