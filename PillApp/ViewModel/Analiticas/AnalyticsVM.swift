//
//  AnalyticsVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 1/6/22.
//

import SwiftUI
import CoreData

final class AnalyticsVM: ObservableObject {
    @Published var parameterTypes: [ParameterType] = []
    @Published var parameterChoosed: ParameterType?
    @Published var userParameters: [Parameter] = []
    
    init() {
        parameterTypes = loadParametersTypes()
    }
    
    func loadParametersTypes() -> [ParameterType] {
        guard let urlJson = Bundle.main.url(forResource: "measurementTypes", withExtension: "json") else {
            print("Json not find")
            return []
        }
        
        do {
            let data = try Data(contentsOf: urlJson)
            return try JSONDecoder().decode([ParameterType].self, from: data)
        } catch {
            print("Error loading measurement types: \(error)")
            return []
        }
    }
    
    func loadParameters(context: NSManagedObjectContext) {
        if let parameter = parameterChoosed {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Parameter")
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Parameter.date, ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "type = %@", NSNumber(value: parameter.id))
            
            do {
                userParameters = try context.fetch(fetchRequest) as! [Parameter]
                print("DATOS CARGADOS")
            } catch {
                print("ERROR loading user parameters: \(error.localizedDescription)")
            }
        }
        
    }
    
    func addNewElement(parameter: Parameter) {
        print("Se añade el elemento a la lista \(parameter.value)")
    }
    
    func deleteUserParameter(indexSet: IndexSet) {
        
    }
    
}
