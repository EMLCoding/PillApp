//
//  DetalleMedicinaView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/3/22.
//

import SwiftUI

struct DetalleMedicinaApiView: View {
    var medicament: MedicineAPI
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                
                ImageViewSlider(imageSliderVM: ImageSliderVM(images: medicament.fotos ?? []))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(height: 200)
                
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
                
                HStack {
                    Image(systemName: "doc.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                    /*
                     Link("Ver Prospecto", destination: URL(string: urlProspecto)!)
                     .foregroundColor(Color("MainColor"))
                     .disabled(urlProspecto == "")
                     .padding(.leading, 10)
                     */
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
        DetalleMedicinaApiView(medicament: MedicineAPI(id: "", nombre: "", labtitular: "", cpresc: "", viasAdministracion: nil, docs: nil, fotos: nil))
    }
}
