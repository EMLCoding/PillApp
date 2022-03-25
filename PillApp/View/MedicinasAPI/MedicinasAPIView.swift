//
//  MedicinasAPIView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 27/2/22.
//

import SwiftUI

struct MedicinasAPIView: View {
    @ObservedObject var medicinesAPIVM: MedicinasAPIVM
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                List {
                    ForEach(medicinesAPIVM.searchedMedicines) { medicine in
                        NavigationLink(medicine.nombre.capitalized) {
                            DetalleMedicinaApiView(medicament: medicine)
                        }
                        .onAppear {
                            if medicine.id == medicinesAPIVM.searchedMedicines.last?.id {
                                medicinesAPIVM.page += 1
                            }
                        }
                    }
                    
                }
                
            }
            .navigationTitle("Search a medicine")
            .searchable(text: $medicinesAPIVM.query)
        }
    }
}

struct MedicinasAPIView_Previews: PreviewProvider {
    static var previews: some View {
        MedicinasAPIView(medicinesAPIVM: MedicinasAPIVM())
    }
}
