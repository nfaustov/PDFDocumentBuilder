//
//  RecognitionService.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import Foundation
import Combine

final class RecognitionService: Recognition {
    let networkController: NetworkControllerProtocol

    init(networkController: NetworkControllerProtocol = NetworkController()) {
        self.networkController = networkController
    }

    func recognizePassport(data: String, token: String) -> AnyPublisher<PassportDataResponse, Error> {
        let endpoint = Endpoint.recognizePassport(data: data)
        var headers: [String: Any] = ["Authorization": "JWT \(token)"]

        endpoint.headers.keys.forEach { key in
            headers[key] = endpoint.headers[key]
        }

        return networkController.post(
            type: PassportDataResponse.self,
            url: endpoint.url,
            headers: headers,
            body: endpoint.body
        )
    }
}
