//
//  RoutineTestView.swift
//  TrainingLog
//
//  Created by Garrett Curtis on 12/31/25.
//  Created for Issue #9 - Core Data Testing
//

import SwiftUI
import CoreData

struct RoutineTestView: View {
    // Access to Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all Routines from Core Data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.name, ascending: true)],
        animation: .default)
    private var routines: FetchedResults<Routine>
    
    var body: some View {
        NavigationView {
            VStack {
                // Button to save test data
                Button(action: saveTestData) {
                    Label("Save Test Routine", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                // List to display all routines
                List {
                    ForEach(routines) { routine in
                        RoutineRowView(routine: routine)
                    }
                    .onDelete(perform: deleteRoutines)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Core Data Test")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    // MARK: - Save Test Data
    private func saveTestData() {
        // Create a new Routine
        let newRoutine = Routine(context: viewContext)
        newRoutine.name = "Test Routine \(Date().formatted(date: .omitted, time: .shortened))"
        newRoutine.notes = "This is a test routine created on \(Date().formatted())"
        
        // Create an Exercise
        let exercise = Exercise(context: viewContext)
        exercise.name = "Bench Press"
        exercise.notes = "Barbell bench press"
        exercise.repMin = 8
        exercise.repMax = 12
        exercise.weightIncrement = 5.0
        exercise.routine = newRoutine
        
        // Create a few SetLogs
        for i in 1...3 {
            let setLog = SetLog(context: viewContext)
            setLog.date = Date()
            setLog.weight = Double(135 + (i * 10))
            setLog.reps = Int16(10 - i)
            setLog.notes = "Set \(i)"
            setLog.exercise = exercise
        }
        
        // Save to Core Data
        do {
            try viewContext.save()
            print("✅ Test data saved successfully!")
        } catch {
            let nsError = error as NSError
            print("❌ Error saving:  \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Delete Routines
    private func deleteRoutines(offsets: IndexSet) {
        withAnimation {
            offsets.map { routines[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("❌ Error deleting: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK:  - Routine Row View
struct RoutineRowView: View {
    @ObservedObject var routine: Routine
    
    var body:  some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(routine.name ??  "Unnamed Routine")
                .font(.headline)
            
            if let notes = routine.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Show exercise count
            if let exercises = routine.exercises {
                Text("\(exercises.count) exercise(s)")
                    .font(. caption)
                    .foregroundColor(.blue)
                
                // Show each exercise and its sets
                ForEach(exercises.array as!  [Exercise]) { exercise in
                    HStack {
                        Text("• \(exercise.name ??  "Unknown")")
                            .font(.subheadline)
                        Spacer()
                        if let setLogs = exercise.setLogs {
                            Text("\(setLogs.count) sets")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 16)
                }
            }
        }
        .padding(. vertical, 4)
    }
}

#Preview {
    RoutineTestView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
