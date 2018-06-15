//
//  Horario.swift
//  appInterface
//
//  Created by Vitor Noro on 10/06/2018.
//  Copyright © 2018 Vitor Noro. All rights reserved.
//

import UIKit

struct Horario: Codable {
    let id: String
    let hora: String
    let destino: String
    let empresa: String
    let cais: String
    let tipo: String
}

struct Habitual: Codable {
    let id: String
    let hora: String
    let destino: String
    let empresa: String
}

