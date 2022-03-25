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
                
                List {
                    ImageViewSlider(imageSliderVM: ImageSliderVM(images: medicament.fotos ?? []))
                        .frame(height: 300)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
        
    }
}

struct DetalleMedicinaApiView_Previews: PreviewProvider {
    static var previews: some View {
        DetalleMedicinaApiView(medicament: MedicineAPI(id: "", nombre: "", labtitular: "", cpresc: "", viasAdministracion: nil, docs: nil, fotos: nil))
    }
}
