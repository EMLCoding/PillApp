//
//  MedicinasAPIVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 27/2/22.
//

import SwiftUI

final class MedicinasAPIVM: ObservableObject {
    var task: Task<(), Never>?
    
    @Published var searchedMedicines: [MedicineAPI] = []
    @Published var isLoadingData = false
    
    @Published var query = "" {
        didSet {
            page = 1
            allResultsFound = false
            
            if !query.isEmpty {
                if task != nil {
                    task?.cancel()
                    print("PETICION CANCELADA")
                }
                task = Task { await find() }
            } else {
                searchedMedicines.removeAll()
            }
        }
    }
    
    @Published var page = 1
    @Published var dataSheetURL = ""
    @Published var leaftletURL = ""
    
    var allResultsFound = false
    
    /// Metodo que lanzara la peticion asincrona cada vez que se llegue al final del listado
    func launchAsync() {
        if !allResultsFound {
            Task(priority: .high) {
                await find()
            }
        }
    }
    
    /// Recupera de forma asíncrona las medicinas de la API de medicinas de CIMA.
    @MainActor func find() async {
        do {
            if (query == "") {
                searchedMedicines.removeAll()
                allResultsFound = false
            } else {
                isLoadingData = true
                let decoder = JSONDecoder()
                let (data, _) = try await URLSession.shared.data(from: .urlMedicines(name: query, page: page))
                let result = try decoder.decode(Results.self, from: data)
                if self.page == 1 {
                    self.searchedMedicines.removeAll()
                }
                if result.resultados.count == 0 {
                    allResultsFound = true
                } else {
                    searchedMedicines.append(contentsOf: result.resultados)
                }
                isLoadingData = false
            }
        } catch {
            print("Error recuperando la lista de medicinas \(error)")
        }
    }
    
    /// Recupera la url del documento de una medicina, en función del tipo
    ///
    ///  - Parameter medicament: Objeto de la medicina --> (MedicineAPI)
    ///  - Parameter type: Tipo del documento que se quiere obtener. --> (String)
    ///  - Returns: String
    func getFile(_ medicament: MedicineAPI, type: Int) -> String {
        if let docs = medicament.docs, let document = docs.filter({ $0.tipo == type}).first {
            return document.url
        } else {
            return ""
        }
    }
}
