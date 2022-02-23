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
