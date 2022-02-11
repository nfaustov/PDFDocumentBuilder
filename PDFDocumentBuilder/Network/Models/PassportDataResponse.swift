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
