//
//  ContentView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    @State private var showBlurEffect = false
    @State private var alertData = AlertData.empty
    
    var body: some View {
        ZStack {
            TabView {
                MedicinasView(medicinesVM: MedicinesVM())
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                MedicinasAPIView(medicinesAPIVM: MedicinasAPIVM())
                    .tabItem {
                        Label("Medicines", systemImage: "pills")
                    }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showAlert)) { notification in
                if let data = notification.object as? AlertData {
                    showAlert = true
                    alertData = data
                }
                showBlurEffect = true
            }
            .onReceive(NotificationCenter.default.publisher(for: .hideAlert)) { _ in
                showAlert = false
                showBlurEffect = false
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertData.title), message: Text(alertData.text), dismissButton: .default(Text(alertData.textButton ?? "Got it")))
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
