//
//  ContentView.swift
//  TrainingLog
//
//  Created by Garrett Curtis on 12/30/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            RoutineTestView()
                .tabItem {
                    Label("Test", systemImage: "flask")
                }
            
            VStack(spacing: 16) {
#if DEV_MODE
                Text("DEV MODE ACTIVE").foregroundColor(.red).bold()
#else
                Text("Production Mode").foregroundColor(.green)
#endif
                Text("Welcome to TrainingLog")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                
                // Add your real content here
            }
            .padding()
            .tabItem {
                Label("Home", systemImage: "house")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
