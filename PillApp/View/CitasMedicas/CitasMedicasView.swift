//
//  CitasMedicasView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 13/4/22.
//

import SwiftUI

struct CitasMedicasView: View {
    
    @State var currentDate = Date()
    @State var isShowingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                VStack {
                    DayPickerView(dayPickerVM: DayPickerVM(), currentDate: $currentDate)
                    
                    CitasMedicasListView(currentDate: currentDate)
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
                }
            }
        }
    }
}

struct CitasMedicasView_Previews: PreviewProvider {
    static var previews: some View {
        CitasMedicasView()
    }
}
