//
//  Model.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import Foundation

struct Medicine: Identifiable {
    let id: UUID
    let name: String
    let date: Date
    let category: CategoryMedicine
    let icon: Icon
}

struct CategoryMedicine: Identifiable {
    let id: UUID
    let name: String
}

struct Icon: Identifiable {
    let id: UUID
    let name: String
}
