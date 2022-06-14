//
//  Model.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI
import MapKit

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

// MARK: - Stored Data
enum Categories: String, Identifiable, CaseIterable {
    case others = "Others"
    case analgesic = "Analgesic"
    case antacid = "Antacid"
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
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title:Categories) -> String {
        return title.localizedString()
    }
    
}

enum Icons: String, Identifiable, CaseIterable {
    case bandage = "Band aid"
    case crossCase = "First aid kit"
    case heart = "Heart"
    case pills = "Pills"
    
    var id: Icons {self}
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    func getIconName() -> String {
        switch self {
        case .bandage:
            return "bandage"
        case .crossCase:
            return "crossCase"
        case .heart:
            return "heart"
        case .pills:
            return "pills"
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

enum DoctorTypes: String, Identifiable, CaseIterable {
    case others = "Others"
    case allergology = "Allergology"
    case anesthetist = "Anesthetist"
    case digestiveSystem = "Digestive system"
    case cardiology = "Cardiology"
    case endocrine = "Endocrine"
    case geriatrics = "Geriatrics"
    case hermatology = "Hermatology"
    case sport = "Medicine of physical education and sports"
    case spaces = "Space medicine"
    case intensive = "Intensive medicine"
    case interna = "Internal Medicine"
    case headboard = "GP"
    case work = "Work medicine"
    case nephrology = "Nephrology"
    case pneumology = "Pneumology"
    case neurology = "Neurology"
    case clinical = "Clinical neurophysiology"
    case oncology = "Oncology"
    case pediatrics = "Pediatrics"
    case psychology = "Psychology"
    case dentist = "Dentist"
    case ophthalmology = "Ophthalmology"
    case rehabilitation = "Rehabilitation"
    case rheumatology = "Rheumatology"
    case urology = "Urology"
    case chiropody = "Chiropody"
    case otorhinolaryngology = "Otorhinolaryngology"
    case analytics = "Analytics"

    var id: DoctorTypes {self}
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getTitleFor(title:DoctorTypes) -> String {
        return title.localizedString()
    }
}

// MARK: - Alert
struct AlertData {
    let title: String
    let image: String
    let text: String
    let textButton: String?
    
    static let empty = AlertData(title: "", image: "", text: "", textButton: nil)
}

// MARK: - Map
struct Ubication: Identifiable {
    let id: Int
    let name: String
    var coordinate: CLLocationCoordinate2D
}

// MARK: - For Keyboard
enum MedicamentsField {
    case name, notes
}

enum MAppoitmentField {
    case notes
}

enum ParametersField {
    case value
}

// MARK: - Analytics
struct ParameterType: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let minValueM: Double
    let maxValueM: Double
    let minValueF: Double?
    let maxValueF: Double?
    let descriptionEs: String
    let descriptionEn: String
    let unit: String
}

