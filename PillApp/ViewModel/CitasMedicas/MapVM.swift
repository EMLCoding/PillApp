//
//  MapVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 18/4/22.
//

import SwiftUI
import MapKit
import CoreLocation

final class MapVM: NSObject, ObservableObject, CLLocationManagerDelegate, MKLocalSearchCompleterDelegate {
    @Published var mapView = MKMapView()
    
    @Published var region: MKCoordinateRegion!
    
    // Alerta
    @Published var permissionDenied = false
    
    // Palabra buscada
    @Published var searchText = ""
    
    // Localizacion en la que añadir una anotacion en el mapa
    @Published var localization = ""
    
    // Array de localizaciones encontradas con el buscador
    @Published var localizations: [MKLocalSearchCompletion] = []
    var searchCompleter = MKLocalSearchCompleter()
    
    /// Comprueba si el usuario ha dado los permisos necesarios para utilizar la ubicación del dispositivo
    ///
    ///  - Parameter manager: (CLLocationManager)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            // Acceso denegado. Muestra una alerta
            permissionDenied.toggle()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            ()
        }
    }
    
    /// Maneja los errores del MapView
    ///
    ///  - Parameter manager: (CLLocationManager)
    ///  - Parameter didFailWithError: (Error)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    /// Para obtener la region del usuario segun su localizacion
    ///
    ///  - Parameter manager: (CLLocationManager)
    ///  - Parameter didUpdateLocations: [CLLocation]
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let latitud = userLocation.coordinate.latitude
        let longitud = userLocation.coordinate.longitude
        let localizacionUsuario: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitud, longitud)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(localization) { [weak self] placemarks, error in
            if let placemark = placemarks?.first{
                let mark = MKPlacemark(placemark: placemark)
                self?.mapView.addAnnotation(mark)
                self?.fitMapViewToAnnotaionList(localizacionUsuario: localizacionUsuario)
            }
        }
    }
    
    /// Permite hacer el maximo zoom posible en el mapa y mostrar la ubicacion del usuario y la anotacion
    ///
    ///  - Parameter localizacionUsuario: (CLLocationCoordinate2D)
    func fitMapViewToAnnotaionList(localizacionUsuario: CLLocationCoordinate2D) -> Void {
        var zoomRect = MKMapRect.null
        for anotacion in mapView.annotations {
            let puntoAnotacion = MKMapPoint(anotacion.coordinate)
            let pointRect = MKMapRect(x: puntoAnotacion.x, y: puntoAnotacion.y, width: 0, height: 0)
            if (zoomRect.isNull) {
                zoomRect = pointRect
            } else {
                zoomRect = zoomRect.union(pointRect)
            }
        }
        
        let puntoUser:MKMapPoint = MKMapPoint(localizacionUsuario)
        let rect:MKMapRect = MKMapRect(x: puntoUser.x, y: puntoUser.y, width: 0.1, height: 0.1)
        
        if zoomRect.isNull {
            zoomRect = rect
        } else {
            zoomRect = zoomRect.union(rect)
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40), animated: true)
    }
    
    /// Abre la aplicación de mapas con los datos ya cargados para ver la ruta
    ///
    func seeEnMap() {
        if (mapView.annotations.count > 0) {
            let anotacion = mapView.annotations[0]
            let puntoAnotacion = MKMapPoint(anotacion.coordinate)
            let latitud = puntoAnotacion.coordinate.latitude
            let longitud = puntoAnotacion.coordinate.longitude
            let coordinate = CLLocationCoordinate2DMake(latitud,longitud)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "Target location" //TODO: Traducir
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
        
    }
}
