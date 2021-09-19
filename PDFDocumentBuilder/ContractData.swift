//
//  ContractData.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.07.2021.
//

import Foundation

struct PassportData: Decodable {
    enum CodingKeys: String, CodingKey {
        case name, surname, patronymic, gender, birthday, birthplace, authority
        case seriesNumber = "series_number"
        case issueDate = "issue_date"
        case authorityCode = "authority_code"
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
    let authorityCode: String
}

struct Patient {
    let id: UUID?
    let name: String
    let passport: PassportData

    init(id: UUID? = UUID(), passport: PassportData) {
        self.id = id
        self.passport = passport
        name = passport.surname + passport.name + passport.patronymic
    }
}

struct Service {
    let title: String
    let price: Double
}
