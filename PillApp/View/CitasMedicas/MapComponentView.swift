//
//  MapComponentView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 18/4/22.
//

import SwiftUI
import MapKit

struct MapComponentView: UIViewRepresentable {
    @ObservedObject var mapVM: MapVM
    
    func makeCoordinator() -> Coordinator {
        return MapComponentView.Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = mapVM.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    class Coordinator: NSObject, MKMapViewDelegate {}
}

