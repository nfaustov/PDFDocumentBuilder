//
//  PassportDataResponse.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import Foundation

struct PassportDataResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case passportData = "detail"
        case errorMessage = "error_message"
    }

    let passportData: PassportData?
    let errorMessage: String?
}

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
