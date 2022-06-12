//
//  Persistence.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // MARK: - Datos de prueba Core Data
        let pruebaMedicina = Medicinas(context: viewContext)
        pruebaMedicina.id = UUID()
        pruebaMedicina.name = "Test medicine"
        pruebaMedicina.date = Date.now
        pruebaMedicina.taken = false
        pruebaMedicina.category = Categories(rawValue: "Otros")?.rawValue
        pruebaMedicina.icon = Icons(rawValue: "Tirita")?.rawValue
        pruebaMedicina.notes = "Notes medicament 1"
        
        let pruebaMedicina2 = Medicinas(context: viewContext)
        pruebaMedicina2.id = UUID()
        pruebaMedicina2.name = "Test medicine 2"
        pruebaMedicina2.date = Date.now
        pruebaMedicina2.taken = true
        pruebaMedicina2.category = Categories(rawValue: "Otros")?.rawValue
        pruebaMedicina2.icon = Icons(rawValue: "Tirita")?.rawValue
        pruebaMedicina2.notes = "Notes medicament 2"
        
        let pruebaCitaMedica = CitaMedica(context: viewContext)
        pruebaCitaMedica.id = UUID()
        pruebaCitaMedica.name = "Test medical appointment"
        pruebaCitaMedica.date = Date.now
        pruebaCitaMedica.dateReminder = Date.now
        pruebaCitaMedica.notes = "Test notes"
        pruebaCitaMedica.ubication = "Test ubication"
        
        let pruebaParameter = Parameter(context: viewContext)
        pruebaParameter.id = UUID()
        pruebaParameter.value = 1.1
        pruebaParameter.date = Date.now
        pruebaParameter.type = 1
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "PillApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    static let testMedicine: Medicinas = {
        let context = PersistenceController.preview.container.viewContext
        
        let newMedicine = Medicinas(context: context)
        newMedicine.id = UUID()
        newMedicine.name = "Test medicine"
        newMedicine.date = Date.now
        newMedicine.taken = false
        newMedicine.category = Categories(rawValue: "Otros")?.rawValue
        newMedicine.icon = Icons(rawValue: "Tirita")?.rawValue
        newMedicine.notes = "Notes"
        
        return newMedicine
    }()
    
    static let testMedicalAppointment: CitaMedica = {
        let context = PersistenceController.preview.container.viewContext
        
        let newMedicalAppointment = CitaMedica(context: context)
        newMedicalAppointment.id = UUID()
        newMedicalAppointment.name = "Test medical appointment"
        newMedicalAppointment.date = Date.now
        newMedicalAppointment.dateReminder = Date.now
        newMedicalAppointment.notes = "Test notes"
        newMedicalAppointment.ubication = "Test ubication"
        
        return newMedicalAppointment
    }()
    
    static let testParameter: Parameter = {
        let context = PersistenceController.preview.container.viewContext
        
        let newParameter = Parameter(context: context)
        newParameter.id = UUID()
        newParameter.value = 1.0
        newParameter.date = Date.now
        newParameter.type = 1
        
        return newParameter
    }()
    
    static let testParameterType: ParameterType = ParameterType(id: 1, name: "test type", minValue: 0, maxValue: 100, descriptionEs: "description es", descriptionEn: "description en", unit: "g")
}
