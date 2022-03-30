//
//  DetalleMedicinaView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/3/22.
//

import SwiftUI

struct DetalleMedicinaApiView: View {
    @ObservedObject var medicinasAPIVM: MedicinasAPIVM
    
    var medicament: MedicineAPI
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                
                if (!(medicament.fotos?.isEmpty ?? true)) {
                    ImageViewSlider(imageSliderVM: ImageSliderVM(images: medicament.fotos ?? []))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 200)
                        .padding(.bottom)
                }
                
                HStack {
                    Image(systemName: "heart.text.square")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text(medicament.nombre.capitalized)
                        .padding(.leading, 10)
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "cross.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text(medicament.labtitular)
                        .padding(.leading, 10)
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text(medicament.cpresc)
                        .padding(.leading, 10)
                }
                
                Divider()
                
                if (!(medicament.docs?.filter {$0.tipo == 1}.isEmpty ?? true)) {
                    HStack {
                        Image(systemName: "doc.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                        NavigationLink("See data sheet") {
                            PdfView(url: medicinasAPIVM.getFile(medicament, type: 1))
                        }
                        .padding(.leading, 10)
                    }
                }
                
                if (!(medicament.docs?.filter {$0.tipo == 2}.isEmpty ?? true)) {
                    HStack {
                        Image(systemName: "doc.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                        NavigationLink("See leaflet") {
                            PdfView(url: medicinasAPIVM.getFile(medicament, type: 2))
                        }
                        .padding(.leading, 10)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        
    }
}

struct DetalleMedicinaApiView_Previews: PreviewProvider {
    static var previews: some View {
        DetalleMedicinaApiView(medicinasAPIVM: MedicinasAPIVM(), medicament: MedicineAPI(id: "", nombre: "", labtitular: "", cpresc: "", viasAdministracion: nil, docs: nil, fotos: nil))
    }
}
