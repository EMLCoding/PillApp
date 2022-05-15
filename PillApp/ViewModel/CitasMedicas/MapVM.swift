//
//  MapVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 18/4/22.
//

import SwiftUI
import MapKit
import CoreLocation

final class MapVM: ObservableObject {
    
    @Published var region: MKCoordinateRegion!
    
    // Localizacion en la que añadir una anotacion en el mapa
    @Published var localization = ""
    
    @Published var annotations: [Ubication] = []
    
    init(localization: String) {
        self.localization = localization
        getAnnotations()
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
    /// Guarda en el array de anotaciones la localización almacenada en la cita médica
    func getAnnotations() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(localization) { [weak self] placemarks, error in
            if let placemark = placemarks?.first{
                let mark = MKPlacemark(placemark: placemark)
                self?.annotations.append(Ubication(id: 1,name: self?.localization ?? "", coordinate: CLLocationCoordinate2D(latitude: mark.coordinate.latitude, longitude: mark.coordinate.longitude)))
                self?.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mark.coordinate.latitude, longitude: mark.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            }
        }
    }
    
    /// Abre la aplicación de mapas con los datos ya cargados para ver la ruta
    ///
    func seeEnMap() {
        annotations.forEach { annotation in
            let coordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude,annotation.coordinate.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "Target location" //TODO: Traducir
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
