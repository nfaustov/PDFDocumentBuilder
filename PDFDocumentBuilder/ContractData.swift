//
//  ContractData.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.07.2021.
//

import Foundation

final class Patient {
    let id: UUID?
    let name: String
    let passport: PassportData

    init(id: UUID? = UUID(), passport: PassportData) {
        self.id = id
        self.passport = passport
        name = passport.surname + " " + passport.name + " " + passport.patronymic
    }
}

final class PriceList: Decodable {
    let categories: [ServicesCategory]

    init() {
        categories = Bundle.main.decode([ServicesCategory].self, from: "servicesCatalog")
    }
}

final class ServicesCategory: Decodable {
    let category: String
    let subcategories: [ServicesCategory]?
    let services: [Service]?
}

struct Service: Decodable, Hashable {
    let title: String
    let price: Double
}
