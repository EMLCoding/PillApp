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
    //@Published var userParameters: [Parameter] = []
    
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
    
    func loadParameters(context: NSManagedObjectContext) -> [Parameter] {
        if let parameter = parameterChoosed {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Parameter")
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Parameter.date, ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "type = %@", NSNumber(value: parameter.id))
            
            do {
                return try context.fetch(fetchRequest) as! [Parameter]
            } catch {
                print("ERROR loading user parameters: \(error.localizedDescription)")
                return []
            }
        } else {
            return []
        }
    }
    
    func deleteUserParameterAt(indexSet: IndexSet, userParameters: [Parameter], context: NSManagedObjectContext) {
        if let userParameter = indexSet.map({ userParameters[$0] }).first {
            Task {
                try await deleteParameter(context: context, parameter: userParameter)
//                if let indexDelete = userParameters.firstIndex(of: userParameter) {
//                    userParameters.remove(at: indexDelete)
//                }
            }
        }
    }
    
    func deleteParameter(context: NSManagedObjectContext, parameter: Parameter) async throws {
        context.delete(parameter)
        do {
            try context.save()
        } catch {
            print("ERROR deleting user parameter value: \(error.localizedDescription)")
        }
    }
    
    func getValuesOf(parameters: [Parameter]) -> [CGFloat] {
        var values: [CGFloat] = []
        
        parameters.reversed().forEach { parameter in
            values.append(parameter.value)
        }
        
        return values
    }
    
}
