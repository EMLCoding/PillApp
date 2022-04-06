//
//  Model.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import Foundation
import SwiftUI

struct Medicine: Identifiable {
    let id: UUID
    let idGroup: UUID
    let name: String
    let date: Date
    var category: String
    var icon: String
    var taken: Bool
    var notes: String
    
    var medicineCategory: Categories {
        set {
            category = newValue.rawValue
        }
        get {
            Categories(rawValue: category) ?? .others
        }
    }
    
    var medicineIcon: Icons {
        set {
            icon = newValue.rawValue
        }
        get {
            Icons(rawValue: icon) ?? .tirita
        }
    }
}



// MARK: - Objetos para la API de medicinas

struct Results: Decodable {
    var resultados: [MedicineAPI]
}

struct MedicineAPI: Identifiable, Decodable, Hashable {
    var id: String
    var nombre: String
    var labtitular: String
    var cpresc: String
    var viasAdministracion: [ViaAdministracion]?
    var docs: [Docs]?
    var fotos: [Foto]?
    
    enum CodingKeys: String, CodingKey {
        case id = "nregistro"
        case nombre, labtitular, cpresc, viasAdministracion, docs, fotos
    }
}

struct Docs: Decodable, Hashable {
    var tipo: Int
    var url: String
}

struct ViaAdministracion: Decodable, Hashable {
    var id: Int
    var nombre: String
}

struct Foto: Decodable, Hashable {
    var tipo: String
    var url: String
    var fecha: Int
}

// MARK: - Datos almacenados
enum Categories: String, Identifiable, CaseIterable {
    case others = "Others"
    case analgesic = "Analgesic"
    case antacid = "Antacid"
    case antialérgico = "Antialérgico"
    case antiallergy = "Anti-allergy"
    case antibiotic = "Antibiotic"
    case antifungal = "Antifungal"
    case antiviral = "Antiviral"
    case antiparasitic = "Antiparasitic"
    case antiinflammatories = "Anti-inflammatories"
    case antidepressant = "Antidepressant"
    case antipyretic = "Antipyretic"
    case antitussive = "Antitussive"
    case laxative = "Laxative"
    case mucolytic = "Mucolytic"
    case vitamin = "Vitamin"
    
    var id: Categories {self}
    
    // TODO: Pruebas para la traduccion
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title:Categories) -> String {
        return title.localizedString()
    }
    
}

enum Icons: String, Identifiable, CaseIterable {
    case tirita = "Band aid"
    case botiquin = "First aid kit"
    case corazon = "Heart"
    case pastillas = "Pills"
    case frasco = "Vial"
    
    var id: Icons {self}
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    func getIconName() -> String {
        switch self {
        case .tirita:
            return "tirita"
        case .botiquin:
            return "botiquin"
        case .corazon:
            return "corazon"
        case .pastillas:
            return "pastillas"
        case .frasco:
            return "frasco"
        }
    }
    
    static func getTitleFor(title:Icons) -> String {
        return title.localizedString()
    }
}

enum Periodicities: String, Identifiable, CaseIterable {
    case day = "Every day"
    case week = "Once a week"
    case biweekly = "Each 15 days"
    case monthly = "Once a month"
    
    var id: Periodicities {self}
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title:Periodicities) -> String {
        return title.localizedString()
    }
}

enum DaysOfWeek: String, Identifiable, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var id: DaysOfWeek {self}
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title:DaysOfWeek) -> String {
        return title.localizedString()
    }
}

// MARK: - Alert
enum ClicksBoton {
    case ok
    case cancel
    case none
}

struct AlertData {
    let title: String
    let image: String
    let text: String
    let textButton: String?
    
    static let empty = AlertData(title: "", image: "", text: "", textButton: nil)
}

// MARK: - Fields enums
enum FieldDetailMedicaments: Int {
    case name = 1
}
