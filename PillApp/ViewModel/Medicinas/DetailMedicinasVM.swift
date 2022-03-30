//
//  DetailMedicinasVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 19/3/22.
//

import SwiftUI
import CoreData

final class DetailMedicinasVM: ObservableObject {
    @Published var isEdition = false
    @Published var medicineName = ""
    @Published var category: Categories = .others
    @Published var icon: Icons = .pastillas
    
    @Published var initialDate = Date.now
    @Published var finalDate = Date.now
    @Published var medicineDate = Date.now // Se utiliza para la edicion de una medicina
    
    @Published var dailyPeriodicities = [1, 2, 3, 4]
    @Published var dailyPeriodicity = 0
    
    @Published var hourFirstTime = Date.now
    @Published var hourSecondTime = Date.now
    @Published var hourThirdTime = Date.now
    @Published var hourFourthTime = Date.now
    
    @Published var periodicity = Periodicities.day
    @Published var dayOfWeek = DaysOfWeek.monday
    
    
    var medicine: Medicinas?
    
    init(medicine: Medicinas?) {
        if let medicine = medicine {
            self.medicine = medicine
            isEdition = true
            medicineName = medicine.name ?? ""
            print("MEDICINENAME: \(medicineName)")
            category = Categories(rawValue: medicine.category ?? "Others") ?? .others
            icon = Icons(rawValue: medicine.icon ?? "Pills") ?? .pastillas
            medicineDate = medicine.date ?? Date.now
        } else {
            
        }
    }
    
    func save(context: NSManagedObjectContext) {
        Task {
            do {
                if isEdition {
                    try await edit(context: context)
                } else {
                    try await create(context: context)
                }
            } catch {
                print("Error saving data \(error.localizedDescription)")
            }
        }
    }
    
    func create(context: NSManagedObjectContext) async throws{
        let components = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: initialDate), to: Calendar.current.startOfDay(for: finalDate))
        let idGroup = UUID()
        if let days = components.day {
            switch periodicity {
            case .day:
                for day in 0...days {
                    var date = Calendar.current.date(byAdding: .day, value: day, to: initialDate) ?? Date.now
                    
                    for period in 0...dailyPeriodicity {
                        
                        switch period {
                        case 0:
                            let hour = Calendar.current.component(.hour, from: hourFirstTime)
                            let minutes = Calendar.current.component(.minute, from: hourFirstTime)
                            
                            date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date) ?? Date.now
                        case 1:
                            let hour = Calendar.current.component(.hour, from: hourSecondTime)
                            let minutes = Calendar.current.component(.minute, from: hourSecondTime)
                            
                            date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date) ?? Date.now
                        case 2:
                            let hour = Calendar.current.component(.hour, from: hourThirdTime)
                            let minutes = Calendar.current.component(.minute, from: hourThirdTime)
                            
                            date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date) ?? Date.now
                        case 3:
                            let hour = Calendar.current.component(.hour, from: hourFourthTime)
                            let minutes = Calendar.current.component(.minute, from: hourFourthTime)
                            
                            date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date) ?? Date.now
                        default:
                            print("ERROR: Error no controlado")
                        }
                        
                        try await createMedicine(context: context, idGroup: idGroup, date: date)
                    }
                }
            case .week:
                for day in 0...(days + 1) {
                    var date = Calendar.current.date(byAdding: .day, value: day, to: initialDate) ?? Date.now
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE"
                    let dayInWeek = dateFormatter.string(from: date)
                    
                    if dayOfWeek.rawValue == dayInWeek {
                        let hour = Calendar.current.component(.hour, from: hourFirstTime)
                        let minutes = Calendar.current.component(.minute, from: hourFirstTime)
                        
                        date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date) ?? Date.now
                        try await createMedicine(context: context, idGroup: idGroup, date: date)
                    }
                    
                    
                }
            case .biweekly:
                for day in 0...(days + 1) {
                    if (day % 15 == 0) {
                        var date = Calendar.current.date(byAdding: .day, value: day, to: initialDate) ?? Date.now
                        let hour = Calendar.current.component(.hour, from: hourFirstTime)
                        let minutes = Calendar.current.component(.minute, from: hourFirstTime)
                        
                        date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date) ?? Date.now
                        
                        try await createMedicine(context: context, idGroup: idGroup, date: date)
                    }
                }
            case .monthly:
                for day in 0...(days + 1) {
                    if (day % 30 == 0) {
                        var date = Calendar.current.date(byAdding: .day, value: day, to: initialDate) ?? Date.now
                        let hour = Calendar.current.component(.hour, from: hourFirstTime)
                        let minutes = Calendar.current.component(.minute, from: hourFirstTime)
                        
                        date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date) ?? Date.now
                        
                        try await createMedicine(context: context, idGroup: idGroup, date: date)
                    }
                }
            }
        }
    }
    
    func createMedicine(context: NSManagedObjectContext, idGroup: UUID, date: Date) async throws {
        let medicine = Medicinas(context: context)
        let id = UUID()
        medicine.id = id
        medicine.idGroup = idGroup
        medicine.name = medicineName
        medicine.date = date
        medicine.category = category.rawValue
        medicine.icon = icon.rawValue
        
        try await context.perform {
            try context.save()
            Notifications().createNotification(id: id, date: date, element: self.medicineName, type: 1)
            // TODO: Conseguir traducir los parametros
            NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Medication reminder", image: "heart.text.square.fill", text: "Reminders have been created successfully", textButton1: nil))
        }
    }
    
    func edit(context: NSManagedObjectContext) async throws {
        let oldDate = medicine?.date ?? Date.now
        medicine?.name = medicineName
        medicine?.category = category.rawValue
        medicine?.icon = icon.rawValue
        medicine?.date = medicineDate
        
        
        try await context.perform {
            if ((self.medicine?.hasChanges) != nil) {
                print("Se edita la medicina")
                try context.save()
                let id = self.medicine?.id ?? UUID()
                if self.medicineDate != oldDate {
                    print("Se actualiza la notificacion")
                    Notifications().eliminarNotificacion(id: id)
                    Notifications().createNotification(id: id, date: self.medicineDate, element: self.medicineName, type: 1)
                }
                
            }
            
        }
    }
    
    // TODO: Eliminar
    func showDeleteAlert() {
        
    }
    
    func prueba(valor: String) {
        print("ES LA FUNCION DE PRUEBA \(valor)")
    }
    
    func delete(context: NSManagedObjectContext, deleteAll: Bool, medicine: Medicinas) {
        Task {
            do {
                if deleteAll {
                    print("SE ELIMINAN TODOS LOS RECORDATORIOS")
                    try await deleteAllGroup(context: context, medicine: medicine)
                } else {
                    print("SE ELIMINA SOLO ESTE RECORDATORIO")
                    try await deleteOne(context: context, medicine: medicine)
                }
            }
        }
    }
    
    func deleteOne(context: NSManagedObjectContext, medicine: Medicinas) async throws {
        if let id = medicine.id {
            context.delete(medicine)
            do {
                try context.save()
                Notifications().eliminarNotificacion(id: id)
            } catch {
                print("ERROR in medicine delete: \(error.localizedDescription)")
            }
        }
    }
    
    // TODO: Desarrollo para proximas versiones
    func deleteAllGroup(context: NSManagedObjectContext, medicine: Medicinas) async throws {}
}
