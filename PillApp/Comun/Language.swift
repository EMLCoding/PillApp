//
//  Language.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 21/7/22.
//

import SwiftUI

func isSpanish() -> Bool {
    if NSLocale.preferredLanguages[0].contains("es"){
        return true
    } else {
        return false
    }
}


