//
//  CounterService.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 22.01.2022.
//

import Foundation
import Combine

final class CounterService: Counter {
    let networkController: NetworkControllerProtocol

    init(networkController: NetworkControllerProtocol = NetworkController()) {
        self.networkController = networkController
    }

    func countServices(token: String) -> AnyPublisher<CounterResponse, Error> {
        let endpoint = Endpoint.service
        var headers: [String: Any] = ["Authorization": "JWT \(token)"]

        endpoint.headers.keys.forEach { key in
            headers[key] = endpoint.headers[key]
        }

        return networkController.get(type: CounterResponse.self, url: endpoint.url, headers: headers)
    }
}
