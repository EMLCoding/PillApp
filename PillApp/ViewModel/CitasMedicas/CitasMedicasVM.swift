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
            
            if let olderDate = older[0].date, let newerDate = newer[0].date {
                years = olderDate.years(toDate: newerDate)
            }
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func changeDate(year: Int) {
        let calendar = Calendar(identifier: .gregorian)
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        component.year = year
        currentDate = Calendar.current.date(from: component) ?? currentDate
    }
}
