//
//  DayPickerVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

final class DayPickerVM: ObservableObject {
    
    @Published var dates: [Date] = []
    
    init() {
        fetchDates()
    }
    
    func fetchDates() {
        let today = Date.now
        let calendar = Calendar.current
        
        let year = calendar.dateInterval(of: .year, for: today)
        
        guard let thisYear = year?.start else {
            return
        }
        
        print("AÑO: \(year)")
        print("PRIMER DIA: \(thisYear)")
        
        (0...364).forEach { day in
            if let yearDay = calendar.date(byAdding: .day, value: day, to: thisYear) {
                dates.append(yearDay)
            }
        }
    }
}
