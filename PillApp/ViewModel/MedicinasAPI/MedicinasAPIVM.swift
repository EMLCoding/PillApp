//
//  MedicinasAPIVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 27/2/22.
//

import SwiftUI

final class MedicinasAPIVM: ObservableObject {
    @Published var searchedMedicines = [MedicineAPI]()
    
    @Published var query = "" {
        didSet {
            page = 1
            
            print("BUSCADO POR \(query)")
            
            
            Task(priority: .medium) {
                await find()
            }
             
        }
    }
    
    @Published var page = 1 {
        didSet {
            Task(priority: .medium) {
                await find()
            }
        }
    }
    
    
    @MainActor func find() async {
        do {
            if (query == "") {
                searchedMedicines.removeAll()
            } else {
                let decoder = JSONDecoder()
                let (data, _) = try await URLSession.shared.data(from: .urlMedicines(name: query, page: page))
                let result = try decoder.decode(Results.self, from: data)
                if self.page == 1 {
                    self.searchedMedicines.removeAll()
                }
                searchedMedicines.append(contentsOf: result.resultados.sorted(by: { $0.nombre > $1.nombre }))
            }
            
        } catch {
            print("Error recuperando la lista de medicinas \(error)")
        }
    }
}
