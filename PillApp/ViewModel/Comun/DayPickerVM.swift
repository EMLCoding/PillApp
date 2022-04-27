//
//  DayPickerVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

final class DayPickerVM: ObservableObject {
    
    @Published var dates: [Date] = []
    
    init(currentDate: Date) {
        fetchDates(currenDate: currentDate)
    }
    
    /// Esta funcion devuelve array de fechas
    ///
    ///  - Parameter format: El formato en que se va a recuperar la fecha ('dd' devuelve el numero del dia; 'EEE' devulve el nombre del dia reducido).
    ///   - Returns: Devuelve la fecha en formato texto
    func fetchDates(currenDate: Date) {
        let today = currenDate 
        let calendar = Calendar.current
        
        let year = calendar.dateInterval(of: .year, for: today)
        
        guard let firstDayOfYear = year?.start else {
            return
        }
        
        
        (0...364).forEach { day in
            if let yearDay = calendar.date(byAdding: .day, value: day, to: firstDayOfYear) {
                dates.append(yearDay)
            }
        }
    }
    
    
}
