//
//  DetailParameters.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 2/6/22.
//

import SwiftUI
import CoreData

final class DetailParametersVM: ObservableObject {
    
    @Published var isEdition = false
    @Published var parameterValue = 0.0
    @Published var parameterDate = Date.now
    @Published var parameterTypeSelected: ParameterType?
    var userParameters: [Parameter]
    
    var parameter: Parameter?
    let parameterTypes: [ParameterType]
    
    init(parameter: Parameter?, parameterTypes: [ParameterType], userParameters: [Parameter]) {
        if let parameter = parameter {
            isEdition = true
            self.parameter = parameter
            self.parameterValue = parameter.value
            self.parameterDate = parameter.date ?? Date.now
        }
        
        self.parameterTypes = parameterTypes
        if self.parameterTypes.count > 0 {
            self.parameterTypeSelected = parameterTypes.first
        }
        self.userParameters = userParameters
    }
    
    @MainActor
    func save(context: NSManagedObjectContext) {
        Task {
            do {
                if isEdition {
                    try await edit(context: context)
                } else {
                    try await create(context: context)
                }
                NotificationCenter.default.post(name: .loadUserParameters, object: nil)
            } catch {
                print("ERROR saving parameter data: \(error.localizedDescription)")
            }
        }
    }
    
    func create(context: NSManagedObjectContext) async throws {
        if let parameterType = parameterTypeSelected {
            let parameter = Parameter(context: context)
            parameter.id = UUID()
            parameter.type = Int64(parameterType.id)
            parameter.value = parameterValue
            parameter.date = parameterDate
            
            try await context.perform {
                try context.save()
                self.userParameters.append(parameter)
            }
        }
    }
    
    func edit(context: NSManagedObjectContext) async throws {
        parameter?.value = parameterValue
        parameter?.type = Int64(parameterTypeSelected?.id ?? -1)
        parameter?.date = parameterDate
        
        try await context.perform {
            if (self.parameter?.hasChanges != nil) {
                try context.save()
            }
        }
    }
}
