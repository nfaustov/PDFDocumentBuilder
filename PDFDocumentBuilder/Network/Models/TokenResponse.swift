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

    static var placeHolder: Self {
        TokenResponse(token: nil, errorMessage: nil)
    }
}

struct Token: Decodable {
    let access: String
    let refresh: String
}

extension Token {
    init(usingEntity entity: TokenEntity) {
        self.access = entity.access ?? ""
        self.refresh = entity.refresh ?? ""
    }
}
