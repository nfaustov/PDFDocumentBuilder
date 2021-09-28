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

    func verifyToken(token: Token) -> AnyPublisher<TokenVerification, Error> {
        let endpoint = Endpoint.verifyToken(token: token)

        return networkController.post(
            type: TokenVerification.self,
            url: endpoint.url,
            headers: endpoint.headers,
            body: endpoint.body
        )
    }

    func refreshToken(token: Token) -> AnyPublisher<TokenResponse, Error> {
        let endpoint = Endpoint.refreshToken(token: token)

        return networkController.post(
            type: TokenResponse.self,
            url: endpoint.url,
            headers: endpoint.headers,
            body: endpoint.body
        )
    }
}
