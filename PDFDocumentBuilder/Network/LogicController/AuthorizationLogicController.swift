//
//  AuthorizationLogicController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation
import Combine

final class AuthorizationLogicController: LogicController {
    let networkController: NetworkControllerProtocol

    init(networkController: NetworkControllerProtocol) {
        self.networkController = networkController
    }

    func getToken() -> AnyPublisher<TokenResponse, Error> {
        let endpoint = Endpoint.token

        return networkController.get(type: TokenResponse.self, url: endpoint.url, headers: endpoint.headers)
    }
}
