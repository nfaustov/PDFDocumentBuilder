//
//  ContractData.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.07.2021.
//

import Foundation

struct Patient {
    let id: UUID?
    let name: String
    let passport: PassportData

    init(id: UUID? = UUID(), passport: PassportData) {
        self.id = id
        self.passport = passport
        name = passport.surname + " " + passport.name + " " + passport.patronymic
    }
}

struct Service {
    let title: String
    let price: Double
}
