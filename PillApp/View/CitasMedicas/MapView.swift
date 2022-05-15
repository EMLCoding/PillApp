//
//  MapView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 18/4/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @ObservedObject var mapVM: MapVM
    @State var locationManager = CLLocationManager()
    @State var showInfoLocation = false
    
    let annotations: [Ubication] = []
    
    init(mapVM: MapVM) {
        self.mapVM = mapVM
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapVM.region, annotationItems: mapVM.annotations) { location in
                MapAnnotation(coordinate: location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1.0)) {
                    VStack {
                        Text("\(location.name)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous).foregroundColor(Color("MainColor")))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 10)
                        
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("MainColor"))
                    }
                }
            }
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
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapVM: MapVM(localization: ""))
    }
}
