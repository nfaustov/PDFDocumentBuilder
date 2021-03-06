//
//  AuthorizationService.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation
import Combine

final class AuthorizationService: Authorization {
    let networkController: NetworkControllerProtocol

    init(networkController: NetworkControllerProtocol = NetworkController()) {
        self.networkController = networkController
    }

    func getToken() -> AnyPublisher<TokenResponse, Error> {
        let endpoint = Endpoint.token

        return networkController.post(
            type: TokenResponse.self,
            url: endpoint.url,
            headers: endpoint.headers,
            body: endpoint.body
        )
    }
}
