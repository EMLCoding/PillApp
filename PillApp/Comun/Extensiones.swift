//
//  Extensiones.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import Foundation

extension Date {
    /// Esta funcion devuelve una fecha en formato String utilizando el conjunto de formatos de fechas
    ///
    ///  - Parameter format: El formato en que se va a recuperar la fecha ('dd' devuelve el numero del dia; 'EEE' devulve el nombre del dia reducido).
    ///   - Returns: Devuelve la fecha en formato texto
    func extractDate(format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    /// Esta funcion devuelve true o false si dos fechas son iguales
    ///
    ///  - Parameter date: La fecha con la que se va a comparar.
    ///   - Returns: Devuelve un booleano
    func currentDate(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(self, inSameDayAs: date)
    }
}

let urlBase = URL(string: "https://cima.aemps.es/cima/rest/medicamentos")!

extension URL {
    static func urlMedicines(name: String, page: Int) -> URL {
        guard var urlC = URLComponents(url: urlBase, resolvingAgainstBaseURL: false) else {
            return urlBase
        }
        //urlC.path = "nombre=\(name)"
        let pagination = URLQueryItem(name: "pagina", value: String(page))
        if (name != "") {
            let search = URLQueryItem(name: "nombre", value: name)
            urlC.queryItems = [search, pagination]
        } else {
            urlC.queryItems = [pagination]
        }
        
        return urlC.url!
    }
}

extension Notification.Name {
    static let showAlert = Notification.Name("showAlert")
    static let hideAlert = Notification.Name("hideAlert")
    static let activateBlurEffect = Notification.Name("activateBlurEffect")
    static let deactivateBlurEffect = Notification.Name("deactivateBlurEffect")
}
