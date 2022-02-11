//
//  ContractData.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.07.2021.
//

import Foundation

final class Patient {
    let id: UUID?
    let passport: PassportData
//    let placeOfResidence: PlaceOfResidence

    var name: String {
        passport.surname + " " + passport.name + " " + passport.patronymic
    }

    init(id: UUID? = UUID(), passport: PassportData/*, placeOfResidence: PlaceOfResidence*/) {
        self.id = id
        self.passport = passport
//        self.placeOfResidence = placeOfResidence
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

    var allCategories: [ServicesCategory] {
        categories
    }

    func filteredServices(withFilterText filterText: String? = nil, category: ServicesCategory? = nil) -> [Service] {
        if let category = category {
            return categories
                .filter { $0.title == category.title }
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

struct PassportData: Decodable, InputModel {
    enum CodingKeys: String, CodingKey {
        case name, surname, patronymic, gender, birthday, birthplace, authority
        case seriesNumber = "series_number"
        case issueDate = "issue_date"
    }

    let name: String
    let surname: String
    let patronymic: String
    let gender: String
    let seriesNumber: String
    let birthday: String
    let birthplace: String
    let issueDate: String
    let authority: String
}

struct PlaceOfResidence: InputModel {
    let region: String?
    let locality: String
    let streetAdress: String
    let house: String
    let appartment: String?
}
