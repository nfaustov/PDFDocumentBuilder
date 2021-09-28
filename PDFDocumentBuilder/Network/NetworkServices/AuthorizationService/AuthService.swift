//
//  AuthService.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation
import Combine

protocol AuthService: AnyObject {
    var networkController: NetworkControllerProtocol { get }

    func getToken() -> AnyPublisher<TokenResponse, Error>
    func verifyToken(token: Token) -> AnyPublisher<TokenVerification, Error>
    func refreshToken(token: Token) -> AnyPublisher<TokenResponse, Error>
}
