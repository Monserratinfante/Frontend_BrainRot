//
//  Folio.swift
//  caritas
//
//  Created by Regina Gutiérrez Mayorga  on 06/11/25.
//

import Foundation
struct Folio: Identifiable {
    let id: UUID
    var codigo: String
    var fecha: String
    var estado: EstadoFolio
    var descripcion: String
}
