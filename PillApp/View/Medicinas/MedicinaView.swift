//
//  MedicinaView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 20/3/22.
//

import SwiftUI

struct MedicinaView: View {
    let medicine: Medicinas
    
    var body: some View {
        HStack {
            Image(/*Icons(rawValue: medicine.icon ?? "Pills")?.rawValue ??*/ "tirita")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(medicine.name ?? "")
                Text("\(medicine.date?.extractDate(format: "HH:mm") ?? Date.now.extractDate(format: "HH:mm"))")
                HStack {
                    Text("Category: ")
                    Text(medicine.category ?? "")
                }
            }
            .padding(.leading)
            .foregroundColor(.white)
            
        }
        .padding()
        .frame(width: 330)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [.white, Color("InitialGradient"), Color("MainColor")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .contextMenu {
            Button {
                
            } label: {
                Label("Mark as taken", systemImage: "checkmark")
            }
            Button {
                
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        
    }
}

struct MedicinaView_Previews: PreviewProvider {
    static var previews: some View {
        MedicinaView(medicine: PersistenceController.testMedicine)
    }
}
