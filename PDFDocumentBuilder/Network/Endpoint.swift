//
//  Endpoint.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "passrec.ufanet.ru"
        components.path = "/api/v0" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }

    var headers: [String: Any] {
        ["Content-Type": "application/json"]
    }
}

extension Endpoint {
    static var token: Self {
        Endpoint(
            path: "/token/",
            queryItems: [
                URLQueryItem(name: "login", value: "demo_ultramed"),
                URLQueryItem(name: "password", value: "nlh2MXpjFwVk")
            ]
        )
    }
}
