//
//  PriceList.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 13.02.2022.
//

import Foundation

final class PriceList {
    private lazy var categories: [ServicesCategory] = {
        Bundle.main.decode([ServicesCategory].self, from: "servicesPriceList")
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

    var allCategories: [ServicesCategory] {
        categories
    }

    func filteredServices(withFilterText filterText: String? = nil, category: ServicesCategory? = nil) -> [Service] {
        if let filteredCategory = categories.first(where: { $0.title == category?.title }) {
            guard let subcategories = filteredCategory.subcategories else {
                return filteredCategory.services?.filter { $0.contains(filterText) } ?? []
            }

            return subcategories
                .compactMap { $0.services }
                .flatMap { $0 }
                .filter { $0.contains(filterText) }
        } else {
            return allServices.filter { $0.contains(filterText) }
        }
    }
}

struct ServicesCategory: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case title = "category"
        case subcategories, services
    }

    let title: String
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
