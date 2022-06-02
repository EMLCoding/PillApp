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
    
    @State var notShowTutorial = UserDefaults.standard.bool(forKey: "notShowTutorial")
    
    @StateObject var analyticsVM = AnalyticsVM()
    
    var body: some View {
        if (notShowTutorial) {
            TabView {
                MedicinasView(medicinesVM: MedicinesVM())
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                MedicinasAPIView(medicinesAPIVM: MedicinasAPIVM())
                    .tabItem {
                        Label("Medicines", systemImage: "pills")
                    }
                CitasMedicasView(citasMedicasVM: CitasMedicasVM())
                    .tabItem {
                        Label("Schedule", systemImage: "calendar")
                    }
                AnalyticsView()
                    .environmentObject(analyticsVM)
                    .tabItem {
                        Label("Analytics", systemImage: "waveform.path.ecg.rectangle")
                    }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.1)
                
                // Use this appearance when scrolling behind the TabView:
                UITabBar.appearance().standardAppearance = appearance
                // Use this appearance when scrolled all the way up:
                UITabBar.appearance().scrollEdgeAppearance = appearance
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
        } else {
            TutorialView(notShowTutorial: $notShowTutorial)
                .edgesIgnoringSafeArea(.all)
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
