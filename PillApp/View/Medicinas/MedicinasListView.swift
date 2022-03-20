//
//  MedicinesListView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 14/2/22.
//

import SwiftUI

struct MedicinasListView: View {
    //@Binding var currentDate: Date
    var fetchRequest: FetchRequest<Medicinas>
    var userMedicines: FetchedResults<Medicinas> {
        fetchRequest.wrappedValue
    }
    
    /*
    @FetchRequest(sortDescriptors: [SortDescriptor(\Medicinas.id)], predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg) ,animation: .default) var fetchMedicines: FetchedResults<Medicinas>
    */
    init(currentDate: Date) {
        fetchRequest = FetchRequest<Medicinas>(sortDescriptors: [SortDescriptor(\Medicinas.id)], predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg) ,animation: .default)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(userMedicines) { medicine in
                    NavigationLink {
                        DetailMedicinasView(detailMedicinasVM: DetailMedicinasVM(medicine: medicine))
                    } label: {
                        Text(medicine.name ?? "")
                    }

                    
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
