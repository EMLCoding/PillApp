//
//  Extensiones.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI
import UIKit
import CoreLocation

extension Date {
    /// Devuelve una fecha en formato String utilizando el conjunto de formatos de fechas
    ///
    ///  - Parameter format: El formato en que se va a recuperar la fecha ('dd' devuelve el numero del dia; 'EEE' devulve el nombre del dia reducido). --> (String)
    ///  - Returns: String
    func extractDate(format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    /// Devuelve true o false si dos fechas son iguales
    ///
    ///  - Parameter date: La fecha con la que se va a comparar --> (Date)
    ///  - Returns: Bool
    func sameDateAs(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    /// Devuelve un array con todos los años que hay entre dos fechas
    ///
    ///  - Parameter toDate: La fecha con la que se va a comparar. --> (Date)
    ///  - Returns: [Int]
    func years(toDate: Date) -> [Int] {
        var yearsMap:Set<Int> = []
        var date = self
        
        while date <= toDate {
            yearsMap.insert(Int(date.extractDate(format: "yyyy")) ?? 0)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        
        return Array(yearsMap).sorted()
    }
    
    /// Devuelve un bool indicando si la fecha original es anterior a la fecha pasada por parametro
    ///
    ///  - Parameter toDate: La fecha con la que se va a comparar. --> (Date)
    ///  - Returns: Bool
    func isBefore(toDate: Date) -> Bool {
        return self < toDate
    }
}

let urlBase = URL(string: "https://cima.aemps.es/cima/rest/medicamentos")!

extension URL {
    /// Devuelve la URL de la petición de la API de Medicinas de CIMA
    ///
    ///  - Parameter name: Texto escrito en el buscador de medicinas. --> (String)
    ///  - Parameter page: La página de resultados --> (Int)
    ///  - Returns: URL
    static func urlMedicines(name: String, page: Int) -> URL {
        guard var urlC = URLComponents(url: urlBase, resolvingAgainstBaseURL: false) else {
            return urlBase
        }
        let pagination = URLQueryItem(name: "pagina", value: String(page))
        let comerc = URLQueryItem(name: "comerc", value: "1")
        let authorized = URLQueryItem(name: "autorizados", value: "1")
        if (name != "") {
            let search = URLQueryItem(name: "nombre", value: name)
            urlC.queryItems = [search, pagination, comerc, authorized]
        } else {
            urlC.queryItems = [pagination, comerc, authorized]
        }
        
        return urlC.url!
    }
}

extension Notification.Name {
    static let showAlert = Notification.Name("showAlert")
    static let hideAlert = Notification.Name("hideAlert")
    static let updateYears = Notification.Name("updateYears")
    static let updateYearsAppoitment = Notification.Name("updateYearsAppoitment")
    static let loadUserParameters = Notification.Name("loadUserParameters")
}
