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
            List {
                ForEach(medicinesAPIVM.searchedMedicines) { medicine in
                    Text(medicine.nombre.capitalized)
                        .onAppear {
                            if medicine.id == medicinesAPIVM.searchedMedicines.last?.id {
                                medicinesAPIVM.page += 1
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
