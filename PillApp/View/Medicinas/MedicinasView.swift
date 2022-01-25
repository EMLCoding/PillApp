//
//  MedicinasView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

struct MedicinasView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\Medicinas.id)],  animation: .default) var fetchMedicines: FetchedResults<Medicinas>
    @ObservedObject var medicinesVM: MedicinesVM
    
    var body: some View {
        NavigationView {
            VStack {
                DayPickerView(dayPickerVM: DayPickerVM())
                List {
                    ForEach(fetchMedicines) { medicine in
                        Text(medicine.name ?? "")
                    }
                }
            }
            
            .navigationTitle("Medicines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        medicinesVM.addMedicine()
                    } label: {
                        Text("Add")
                    }

                }
            }
        }
    }
}

struct MedicinasView_Previews: PreviewProvider {
    static var previews: some View {
        MedicinasView(medicinesVM: MedicinesVM())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
