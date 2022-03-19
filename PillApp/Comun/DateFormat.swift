//
//  DateFormat.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 19/3/22.
//

import SwiftUI

final class DateFormat {
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first!)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter
    }
}
