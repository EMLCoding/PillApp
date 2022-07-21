//
//  CitasMedicasView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 13/4/22.
//

import SwiftUI

struct CitasMedicasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var citasMedicasVM: CitasMedicasVM
    
    @State var currentDate = Date()
    @State var isShowingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                VStack {
                    DayPickerView(dayPickerVM: DayPickerVM(currentDate: citasMedicasVM.currentDate), currentDate: $citasMedicasVM.currentDate)
                        .frame(height: 120)
                    
                    CitasMedicasListView(currentDate: citasMedicasVM.currentDate)
                }
                .navigationTitle("Medical appointments")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add", action: {isShowingSheet.toggle()})
                            .sheet(isPresented: $isShowingSheet, content: {
                                NavigationView {
                                    DetailCitasMedicasView(detailCitasMedicasVM: DetailCitasMedicasVM(medicalAppoitment: nil))
                                }
                            })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu("Choose year") {
                            ForEach(citasMedicasVM.years, id:\.self) { year in
                                Button {
                                    citasMedicasVM.changeDate(year: year)
                                } label: {
                                    Text(String(year))
                                }
                            }
                        }
                        .disabled(citasMedicasVM.years.count < 2)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            citasMedicasVM.getAllYears(context: viewContext)
        }
        .onReceive(NotificationCenter.default.publisher(for: .updateYearsAppoitment)) { _ in
            citasMedicasVM.getAllYears(context: viewContext)
        }
    }
}

struct CitasMedicasView_Previews: PreviewProvider {
    static var previews: some View {
        CitasMedicasView(citasMedicasVM: CitasMedicasVM())
    }
}
