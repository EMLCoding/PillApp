//
//  MapView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 18/4/22.
//

import SwiftUI
import CoreLocation

struct MapView: View {
    @ObservedObject var mapVM: MapVM
    @State var locationManager = CLLocationManager()
    
    init(mapVM: MapVM, localization: String) {
        self.mapVM = mapVM
        self.mapVM.localization = localization
        self.locationManager.delegate = mapVM
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    var body: some View {
        ZStack {
            MapComponentView(mapVM: mapVM)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Button {
                    mapVM.seeEnMap()
                } label: {
                    Image(systemName: "map")
                        .font(.title2)
                        .padding(10)
                        .background(Color.primary)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()

            }
        }
        .alert(isPresented: $mapVM.permissionDenied, content: {
            Alert(title: Text("Denied permissions"), message: Text("If you want to use the map enable the permissions in the settings"), dismissButton: .default(Text("Go to settings")) {
                // Redirecciona a los ajustes
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapVM: MapVM(), localization: "")
    }
}
