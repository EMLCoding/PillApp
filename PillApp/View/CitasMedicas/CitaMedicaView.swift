//
//  CitaMedicaView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 17/4/22.
//

import SwiftUI

struct CitaMedicaView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var detailCitasMedicasVM = DetailCitasMedicasVM(medicalAppoitment: nil)
    
    @State var showAlert = false
    
    let medicalAppoitment: CitaMedica
    
    var body: some View {
        HStack {
            Image(systemName: "cross.circle")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("MainColor"))
                .frame(width: 40, height: 40)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(medicalAppoitment.name ?? "")
                Text("\(medicalAppoitment.date?.extractDate(format: "HH:mm") ?? Date.now.extractDate(format: "HH:mm"))")
                Text(medicalAppoitment.ubication ?? "")
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
                    await detailCitasMedicasVM.changeState(medicalAppoitment: medicalAppoitment, context: viewContext)
                }
            } label: {
                Label(medicalAppoitment.attended ? "Demark as taken" : "Mark as taken", systemImage: medicalAppoitment.attended ? "minus.circle" : "checkmark")
            }
            Button {
                showAlert = true
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .confirmationDialog("Delete reminder", isPresented: $showAlert) {
            Button(role: .destructive) {
                detailCitasMedicasVM.delete(context: viewContext, medicalAppoitment: medicalAppoitment)
            } label: {
                Text("Delete this reminder")
            }
        } message: {
            Text("Do you want to delete this reminder?")
        }
        
        
    }
}

struct CitaMedicaView_Previews: PreviewProvider {
    static var previews: some View {
        CitaMedicaView(medicalAppoitment: PersistenceController.testMedicalAppointment)
    }
}
