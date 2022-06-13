//
//  DetailCitasMedicasVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 13/4/22.
//

import SwiftUI
import CoreData

final class DetailCitasMedicasVM: ObservableObject {
    
    @Published var appoitmentName: DoctorTypes = .headboard
    @Published var appoitmentNotes = ""
    @Published var date = Date.now
    @Published var dateReminder = Date.now
    @Published var appoitmentLocation = ""
    
    @Published var isEdition = false
    
    var medicalAppoitment: CitaMedica?
    
    init(medicalAppoitment: CitaMedica?) {
        if let medicalAppoitment = medicalAppoitment {
            self.medicalAppoitment = medicalAppoitment
            self.appoitmentName = DoctorTypes(rawValue: medicalAppoitment.name ?? "GP") ?? .headboard
            self.appoitmentNotes = medicalAppoitment.notes ?? ""
            self.date = medicalAppoitment.date ?? Date.now
            self.dateReminder = medicalAppoitment.dateReminder ?? Date.now
            self.appoitmentLocation = medicalAppoitment.ubication ?? ""
            isEdition = true
        }
    }
    
    /// Realiza la llamada a los métodos de guardar los datos. En función de la variable **isEdition** llamará al método **edit** o al método **create** para editar o crear un recordatorio de citas médicas
    ///
    ///  - Parameter context: contexto de la aplicación para la gestión de los datos de Core Data. --> (NSManagedObjectContext)
    @MainActor
    func save(context: NSManagedObjectContext) {
        Task {
            do {
                if isEdition {
                    try await edit(context: context)
                } else {
                    try await create(context: context)
                }
                NotificationCenter.default.post(name: .updateYearsAppoitment, object: nil)
            } catch {
                print("ERROR saving data \(error.localizedDescription)")
            }
        }
    }
    
    /// Realiza la tarea asíncrona de crear un nuevo recordatorio de cita médica. Los errores lanzados (throws) serán gestionados en el método **save**
    ///
    ///  - Parameter context: contexto de la aplicación para la gestión de los datos de Core Data. --> (NSManagedObjectContext)
    func create(context: NSManagedObjectContext) async throws {
        let medicalAppoitment = CitaMedica(context: context)
        let id = UUID()
        medicalAppoitment.id = id
        medicalAppoitment.name = appoitmentName.rawValue
        medicalAppoitment.date = date
        medicalAppoitment.dateReminder = dateReminder
        medicalAppoitment.notes = appoitmentNotes
        medicalAppoitment.ubication = appoitmentLocation
        
        let textNotification = self.appoitmentName.rawValue + " - " + date.extractDate(format: "MMM d, h:mm a")
        
        try await context.perform {
            try context.save()
            Notifications().createNotification(id: id, date: self.dateReminder, element: textNotification, type: 2)
        }
        
    }
    
    /// Realiza la tarea asíncrona de editar un recordatorio de cita médica. Los errores lanzados (throws) serán gestionados en el método 'save'
    ///
    ///  - Parameter context: contexto de la aplicación para la gestión de los datos de Core Data. --> (NSManagedObjectContext)
    func edit(context: NSManagedObjectContext) async throws {
        let oldDate = medicalAppoitment?.dateReminder ?? Date.now
        medicalAppoitment?.name = appoitmentName.rawValue
        medicalAppoitment?.notes = appoitmentNotes
        medicalAppoitment?.date = date
        medicalAppoitment?.dateReminder = oldDate
        medicalAppoitment?.ubication = appoitmentLocation
        
        try await context.perform {
            if ((self.medicalAppoitment?.hasChanges) != nil) {
                try context.save()
                let id = self.medicalAppoitment?.id ?? UUID()
                    let textNotification = self.appoitmentName.rawValue + " - " + self.date.extractDate(format: "MMM d, h:mm a")
                    Notifications().eliminarNotificacion(id: id)
                    Notifications().createNotification(id: id, date: self.dateReminder, element: textNotification, type: 2)                
            }
            
        }
    }
    
    /// Realiza la tarea asíncrona de eliminar un recordatorio de cita médica.
    ///
    ///  - Parameter context: contexto de la aplicación para la gestión de los datos de Core Data. --> (NSManagedObjectContext)
    ///  - Parameter medicalAppoitment: objeto de la cita médica que se quiere eliminar. --> (CitaMedica)
    func delete(context: NSManagedObjectContext, medicalAppoitment: CitaMedica) {
        if let id = medicalAppoitment.id {
            Task {
                context.delete(medicalAppoitment)
                do {
                    try context.save()
                    Notifications().eliminarNotificacion(id: id)
                } catch {
                    print("ERROR deleting medical appoitment: \(error)")
                }
            }
        }
    }
}
