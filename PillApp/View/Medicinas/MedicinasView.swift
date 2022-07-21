//
//  MedicinasView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

struct MedicinasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var medicinesVM: MedicinesVM
    
    @State var isShowingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                VStack {
                    DayPickerView(dayPickerVM: DayPickerVM(currentDate: medicinesVM.currentDate), currentDate: $medicinesVM.currentDate)
                        .frame(height: 120)
                    
                    MedicinasListView(currentDate: medicinesVM.currentDate)
                }
                .navigationTitle("Medication reminders")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add", action: {isShowingSheet.toggle()})
                            .sheet(isPresented: $isShowingSheet, content: {
                                NavigationView {
                                    DetailMedicinasView(detailMedicinasVM: DetailMedicinasVM(medicine: nil))
                                }
                            })                        
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu("Choose year") {
                            ForEach(medicinesVM.years, id:\.self) { year in
                                Button {
                                    medicinesVM.changeDate(year: year)
                                } label: {
                                    Text(String(year))
                                }
                            }
                        }
                        .disabled(medicinesVM.years.count < 2)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            medicinesVM.getAllYears(context: viewContext)
        }
        .onReceive(NotificationCenter.default.publisher(for: .updateYears)) { _ in
            medicinesVM.getAllYears(context: viewContext)
        }
    }
}

struct MedicinasView_Previews: PreviewProvider {
    static var previews: some View {
        MedicinasView(medicinesVM: MedicinesVM())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
