//
//  MedicinesListView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 14/2/22.
//

import SwiftUI

struct MedicinasListView: View {
    var fetchRequest: FetchRequest<Medicinas>
    var userMedicines: FetchedResults<Medicinas> {
        fetchRequest.wrappedValue
    }
    var date = Date.now
    
    init(currentDate: Date) {
        date = currentDate
        fetchRequest = FetchRequest<Medicinas>(sortDescriptors: [SortDescriptor(\Medicinas.date)], predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg) ,animation: .default)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {           
            ForEach(userMedicines) { medicine in
                NavigationLink {
                    DetailMedicinasView(detailMedicinasVM: DetailMedicinasVM(medicine: medicine))
                } label: {
                    MedicinaView(medicine: medicine)
                        .padding(.bottom)
                }
            }
        }
    }
}

struct MedicinasListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicinasListView(currentDate: Date.now)
    }
}
