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
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    init(currentDate: Date) {
        date = currentDate
        fetchRequest = FetchRequest<Medicinas>(sortDescriptors: [SortDescriptor(\Medicinas.date)], predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg) ,animation: .default)
    }
    
    var body: some View {
        if userMedicines.count == 0 {
            Group {
                Spacer()
                
                VStack(alignment: .center) {
                    Image(systemName: "pills.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("MainColor"))
                        .frame(width: 80, height: 80)
                    Text("Add the medications you want me to remind you of.")
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(userMedicines) { medicine in
                        MedicinaView(medicine: medicine)
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
