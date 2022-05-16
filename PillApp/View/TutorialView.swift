//
//  TutorialView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 16/5/22.
//

import SwiftUI

struct TutorialView: View {
    @Binding var notShowTutorial: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to PillApp")
                .bold()
                .font(.system(.title))
                .foregroundColor(Color.white)
                .padding(.top, 60)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.white)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Medication Reminder")
                            .bold()
                            .foregroundColor(.white)
                        Text("Create reminders of your medications to know when to take them")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                HStack {
                    Image(systemName: "pills")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.white)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Drug Finder")
                            .bold()
                            .foregroundColor(.white)
                        Text("Search drugs to see their most relevant information")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.white)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Medical Appointment Reminder")
                            .bold()
                            .foregroundColor(.white)
                        Text("Create reminders of your medical appointments to know when you should go to the doctor")
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .padding(.horizontal, 35)
            
            Spacer()
            
            Button {
                self.notShowTutorial = true
                UserDefaults.standard.set(self.notShowTutorial, forKey: "notShowTutorial")
            } label: {
                Text("Continue")
                    .foregroundColor(Color("MainColor"))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
            }
            
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("MainColor"))
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(notShowTutorial: .constant(true))
    }
}
