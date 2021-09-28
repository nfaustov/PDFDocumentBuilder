//
//  Endpoint.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation

struct Endpoint {
    var path: String
    var body: [String: Any]?
}

extension Endpoint {
    var url: URL {
        guard let url = URL(string: "https://passrec.ufanet.ru/api/v0/" + path) else {
            preconditionFailure("Invalid URL")
        }

        return url
    }

    var headers: [String: Any] {
        ["Content-Type": "application/json"]
    }
}

extension Endpoint {
    static var token: Self {
        let json: [String: Any] = ["login": "demo_ultramed", "password": "nlh2MXpjFwVk"]

        return Endpoint(path: "token/", body: json)
    }

    static func verifyToken(token: Token) -> Self {
        let json: [String: Any] = ["token": token.access, "refresh": token.refresh]

        return Endpoint(path: "token/verify/", body: json)
    }

    static func refreshToken(token: Token) -> Self {
        let json: [String: Any] = ["refresh": token.refresh]

        return Endpoint(path: "token/refresh/", body: json)
    }

    static func recognizePassport(data: String) -> Self {
        let json: [String: Any] = ["file": data]

        return Endpoint(path: "passports/recognition/", body: json)
    }
}
