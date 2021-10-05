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

final class PriceList {
    private lazy var categories: [ServicesCategory] = {
        Bundle.main.decode([ServicesCategory].self, from: "servicesCatalog")
    }()

    private var allServices: [Service] {
        let categoriesServices = categories
            .compactMap { $0.services }
            .flatMap { $0 }
        var subcategoriesServices = categories
            .compactMap { $0.subcategories }
            .flatMap { $0 }
            .compactMap { $0.services}
            .flatMap { $0 }

        subcategoriesServices.append(contentsOf: categoriesServices)

        return subcategoriesServices
    }

    func filteredServices(with filter: String? = nil) -> [Service] {
        allServices.filter { $0.contains(filter) }
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

    func contains(_ filter: String?) -> Bool {
        guard let filterText = filter else { return true }

        if filterText.isEmpty { return true }
        let lowercasedFilter = filterText.lowercased()

        return title.lowercased().contains(lowercasedFilter)
    }
}
