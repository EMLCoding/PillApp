//
//  ContentView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
