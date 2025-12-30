//
//  TrainingLogApp.swift
//  TrainingLog
//
//  Created by Garrett Curtis on 12/30/25.
//

import SwiftUI
import CoreData

@main
struct TrainingLogApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
