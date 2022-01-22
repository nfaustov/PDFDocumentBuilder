//
//  TokenResponse.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation

struct TokenResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case token = "detail"
        case errorMessage = "error_message"
    }

    let token: Token?
    let errorMessage: String?
}

struct Token: Decodable {
    let access: String
    let refresh: String
}
