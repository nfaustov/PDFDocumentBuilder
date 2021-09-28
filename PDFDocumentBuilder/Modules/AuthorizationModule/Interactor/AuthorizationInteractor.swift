//
//  AuthorizationInteractor.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation
import Combine

final class AuthorizationInteractor {
    typealias Delegate = AuthorizationInteractorDelegate
    weak var delegate: Delegate?

    var authorizationService: Authorization?
    var authorizationDatabase: TokenDB?

    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - AuthorizationInteraction

extension AuthorizationInteractor: AuthorizationInteraction {
    func getToken() {
        if let tokenEntity = authorizationDatabase?.getToken() {
            let token = Token(usingEntity: tokenEntity)
            verifyToken(token: token)
        } else {
            authorizationService?.getToken()
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Couldn't get token: \(error.localizedDescription)")
                    case .finished: break
                    }
                }, receiveValue: { [delegate, authorizationDatabase] response in
                    if let token = response.token {
                        authorizationDatabase?.saveToken(token: token)
                        delegate?.tokenDidRecieved()
                    } else if let errorMessage = response.errorMessage {
                        delegate?.tokenFailure(message: errorMessage)
                    } else {
                        delegate?.tokenFailure(message: "Ошибка запроса токена")
                    }
                })
                .store(in: &subscriptions)
        }
    }
}

// MARK: - Private extension

private extension AuthorizationInteractor {
    func verifyToken(token: Token) {
        delegate?.tokenStatus(message: "Верификация...")
        authorizationService?.verifyToken(token: token)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Couldn't verify token: \(error.localizedDescription)")
                case .finished: break
                }
            }, receiveValue: { [delegate, refreshToken] verification in
                if let valid = verification.detail?.valid {
                    valid ? delegate?.tokenDidRecieved() : refreshToken(token)
                } else if let errorMessage = verification.errorMessage {
                    delegate?.tokenFailure(message: errorMessage)
                } else {
                    delegate?.tokenFailure(message: "Ошибка запроса при верификации токена")
                }
            })
            .store(in: &subscriptions)
    }

    func refreshToken(token: Token) {
        delegate?.tokenStatus(message: "Обновление...")
        authorizationService?.refreshToken(token: token)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Couldn't refresh token: \(error.localizedDescription)")
                case .finished: break
                }
            }, receiveValue: { [delegate, authorizationDatabase] response in
                if let token = response.token {
                    authorizationDatabase?.saveToken(token: token)
                    delegate?.tokenDidRecieved()
                } else if let errorMessage = response.errorMessage {
                    delegate?.tokenFailure(message: errorMessage)
                } else {
                    delegate?.tokenFailure(message: "Ошибка за проса при обновлении токена")
                }
            })
            .store(in: &subscriptions)
    }
}
