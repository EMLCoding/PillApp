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
        
        let pruebaMedicina2 = Medicinas(context: viewContext)
        pruebaMedicina2.id = UUID()
        pruebaMedicina2.name = "Test medicine 2"
        pruebaMedicina2.date = Date.now
        pruebaMedicina2.taken = true
        pruebaMedicina2.category = Categories(rawValue: "Otros")?.rawValue
        pruebaMedicina2.icon = Icons(rawValue: "Tirita")?.rawValue
        
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
}
