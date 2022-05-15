//
//  CitasMedicasListView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 13/4/22.
//

import SwiftUI

struct CitasMedicasListView: View {
    var fetchRequest: FetchRequest<CitaMedica>
    var userMedicalAppointments: FetchedResults<CitaMedica> {
        fetchRequest.wrappedValue
    }
    var date = Date.now
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    init(currentDate: Date) {
        date = currentDate
        fetchRequest = FetchRequest<CitaMedica>(sortDescriptors: [SortDescriptor(\CitaMedica.date)], predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg) ,animation: .default)
    }
    
    var body: some View {
        if userMedicalAppointments.count == 0 {
            Group {
                Spacer()
                
                VStack(alignment: .center) {
                    Image(systemName: "cross.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("MainColor"))
                        .frame(width: 80, height: 80)
                    Text("Add the medical appointments you want to be reminded of")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(userMedicalAppointments) { medicalAppointment in
                        NavigationLink {
                            DetailCitasMedicasView(detailCitasMedicasVM: DetailCitasMedicasVM(medicalAppoitment: medicalAppointment))
                        } label: {
                            CitaMedicaView(medicalAppoitment: medicalAppointment)
                                .padding(.bottom)
                        }
                    }
                }
            }
        }
    }
}

struct CitasMedicasListView_Previews: PreviewProvider {
    static var previews: some View {
        CitasMedicasListView(currentDate: Date.now)
    }
}
