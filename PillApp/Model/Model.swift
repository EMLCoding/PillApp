//
//  Model.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import Foundation

struct Medicine: Identifiable {
    let id: UUID
    let idGroup: UUID
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
