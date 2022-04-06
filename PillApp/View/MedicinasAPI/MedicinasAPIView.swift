//
//  MedicinasAPIView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 27/2/22.
//

import SwiftUI

struct MedicinasAPIView: View {
    @ObservedObject var medicinesAPIVM: MedicinasAPIVM
    @AppStorage("hideLanguageDialog") private var hideLanguageDialog = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                List {
                    ForEach(medicinesAPIVM.searchedMedicines) { medicine in
                        NavigationLink(medicine.nombre.capitalized) {
                            DetalleMedicinaApiView(medicinasAPIVM: medicinesAPIVM, medicament: medicine)
                        }
                        .onAppear {
                            if medicine.id == medicinesAPIVM.searchedMedicines.last?.id {
                                medicinesAPIVM.page += 1
                            }
                        }
                    }
                    if (medicinesAPIVM.isLoadingData) {
                        ProgressView()
                            .frame(alignment: .center)
                    }
                }
                
            }
            .navigationTitle("Search medicaments")
            .searchable(text: $medicinesAPIVM.query)
            .onAppear {
                if (!hideLanguageDialog && NSLocale.preferredLanguages[0] != "es") {
                    NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Data Notice", image: "heart.text.square.fill", text: "The medicines that appear in this functionality are only medicines sold in Spain.", textButton: "See spanish info"))
                    hideLanguageDialog = true
                }
                
            }
        }
    }
}

struct MedicinasAPIView_Previews: PreviewProvider {
    static var previews: some View {
        MedicinasAPIView(medicinesAPIVM: MedicinasAPIVM())
    }
}
