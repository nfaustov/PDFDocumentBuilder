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
        guard let url = URL(string: "https://passrec.ufanet.ru:443/api/v0/" + path) else {
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
        guard let login = Bundle.main.object(forInfoDictionaryKey: "Login") as? String,
              let password = Bundle.main.object(forInfoDictionaryKey: "Password") as? String else {
                  preconditionFailure("Cannot find login or password")
              }

        let json: [String: Any] = ["login": login, "password": password]

        return Endpoint(path: "token/", body: json)
    }

    static func recognizePassport(data: String) -> Self {
        let json: [String: Any] = ["file": data]

        return Endpoint(path: "passports/recognition/", body: json)
    }

    static var service: Self {
        Endpoint(path: "service/counters/")
    }
}
