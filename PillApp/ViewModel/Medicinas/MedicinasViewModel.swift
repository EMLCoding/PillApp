//
//  MedicinasViewModel.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

final class MedicinesVM: ObservableObject {
    
    @Published var currentYear = Date.now.extractDate(format: "yyyy")
    
    // TODO: Cambio de fecha
}
