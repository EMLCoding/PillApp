//
//  StreetsFinderVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 18/4/22.
//

import SwiftUI
import MapKit
import CoreLocation

final class StreetsFinderVM: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var direction = "" {
        didSet {
            searchQuery()
        }
    }
    @Published var localizations:[MKLocalSearchCompletion] = []
    
    var searchCompleter = MKLocalSearchCompleter()
    
    func searchQuery() {
        searchCompleter.delegate = self
        searchCompleter.queryFragment = direction
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.localizations = completer.results
    }
}
