//
//  MedicinasView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

struct MedicinasView: View {
    @ObservedObject var medicinesVM: MedicinesVM
    
    @State var currentDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                VStack {
                    DayPickerView(dayPickerVM: DayPickerVM(), currentDate: $currentDate)
                    
                    
                    MedicinasListView(currentDate: currentDate)
                }
                .navigationTitle("Medication reminder")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("Add", destination: DetailMedicinasView(detailMedicinasVM: DetailMedicinasVM(medicine: nil)))
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu("Year") {
                            Button {
                            } label: {
                                Text("\(medicinesVM.currentYear)")
                            }
                            Button {
                                
                            } label: {
                                Text("\(medicinesVM.currentYear)")
                            }
                        }
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
