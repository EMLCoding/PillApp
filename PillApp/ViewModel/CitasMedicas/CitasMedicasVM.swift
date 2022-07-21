//
//  CitasMedicasVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 23/4/22.
//

import SwiftUI
import CoreData

final class CitasMedicasVM: ObservableObject {
    
    @Published var currentYear = Date.now.extractDate(format: "yyyy")
    @Published var years: [Int] = []
    @Published var currentDate = Date.now
    
    /// En función de los datos de citas médicas almacenados en Core Data, se rellenará el array de años, con el que se podrá cambiar el año de visualización en el listado de recordatorios de citas médicas. Coge el elemento con la fecha más vieja y el elemento con la fecha más actual y recupera los años, no el número de años, que hay entre ambas fechas
    ///
    ///  - Parameter context: contexto de la aplicación para la gestión de los datos de Core Data. --> (NSManagedObjectContext)
    func getAllYears(context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CitaMedica")
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Medicinas.date, ascending: true)
        ]
        do {
            let older = try context.fetch(fetchRequest) as! [CitaMedica]
            
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Medicinas.date, ascending: false)
            ]
            let newer = try context.fetch(fetchRequest) as! [CitaMedica]
            
            if (older.count > 0) {
                if let olderDate = older[0].date, let newerDate = newer[0].date {
                    if newerDate.isBefore(toDate: Date.now) {
                        years = olderDate.years(toDate: Date.now)
                    } else {
                        years = olderDate.years(toDate: newerDate)
                    }
                }
            } else {
                years = Date.now.years(toDate: Date.now)
            }
            
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    /// Cambia el año de la fecha actual por el año seleccionado en el menú desplegable de años, para mostrar las fechas y recordatorios de dicho año
    ///
    ///  - Parameter year: Año seleccionado. --> (Int)
    func changeDate(year: Int) {
        let calendar = Calendar(identifier: .gregorian)
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        component.year = year
        currentDate = Calendar.current.date(from: component) ?? currentDate
    }
}
