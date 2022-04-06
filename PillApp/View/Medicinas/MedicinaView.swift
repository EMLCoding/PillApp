//
//  MedicinaView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 20/3/22.
//

import SwiftUI

struct MedicinaView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var detailMedicinasVM = DetailMedicinasVM(medicine: nil)
    
    @State var showAlert = false
    
    let medicine: Medicinas
    
    var body: some View {
        HStack {
            // TODO: Arreglar
            Image(Icons(rawValue: medicine.icon ?? "Pills")?.getIconName() ?? "tirita")
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
                Task {
                    await detailMedicinasVM.changeState(medicament: medicine, context: viewContext)
                }
            } label: {
                Label(medicine.taken ? "Demark as taken" : "Mark as taken", systemImage: medicine.taken ? "minus.circle" : "checkmark")
            }
            Button {
                showAlert = true
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .confirmationDialog("Delete reminder", isPresented: $showAlert) {
            Button(role: .destructive) {
                detailMedicinasVM.delete(context: viewContext, medicine: medicine, deleteAll: false)
            } label: {
                Text("Delete this reminder")
            }
            
            Button(role: .destructive) {
                detailMedicinasVM.delete(context: viewContext, medicine: medicine, deleteAll: true)
            } label: {
                Text("Delete all reminder group")
            }

        } message: {
            Text("Do you want to delete this reminder or all future reminders for this medication?")
        }
        
        
    }
    
}

struct MedicinaView_Previews: PreviewProvider {
    static var previews: some View {
        MedicinaView(medicine: PersistenceController.testMedicine)
    }
}
