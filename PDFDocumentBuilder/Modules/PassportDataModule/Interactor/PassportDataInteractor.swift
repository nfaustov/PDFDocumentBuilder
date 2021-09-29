//
//  PassportDataInteractor.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import Foundation
import Combine

final class PassportDataInteractor {
    typealias Delegate = PassportDataInteractorDelegate
    weak var delegate: Delegate?

    var recognitionService: Recognition?
    var authorizationDatabase: TokenDB?
    var authorizationService: Authorization?

    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - PassportDataInteraction

extension PassportDataInteractor: PassportDataInteraction {
    func recognizePassport(data: String, token: Token) {
        delegate?.recognitionStatus(message: "Распознавание паспортных данных...")
        recognitionService?.recognizePassport(data: data, token: token.access)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Couldn't recognize passport: \(error.localizedDescription)")
                case .finished: break
                }
            }, receiveValue: { [delegate] response in
                if let passportData = response.passportData {
                    delegate?.passportDidRecognized(passportData)
                } else if let errorMessage = response.errorMessage {
                    delegate?.recognitionFailure(message: errorMessage)
                } else {
                    delegate?.recognitionFailure(message: "Ошибка запроса")
                }
            })
            .store(in: &subscriptions)
    }

    func verifyToken() {
        if let tokenEntity = authorizationDatabase?.getToken() {
            delegate?.recognitionStatus(message: "Верификация...")

            let token = Token(usingEntity: tokenEntity)
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
                        valid ? delegate?.tokenDidReceived(token) : refreshToken(token)
                    } else if let errorMessage = verification.errorMessage {
                        delegate?.recognitionFailure(message: errorMessage)
                    } else {
                        delegate?.recognitionFailure(message: "Ошибка запроса при верификации токена")
                    }
                })
                .store(in: &subscriptions)
        } else {
            delegate?.recognitionStatus(message: "Обновление...")

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
                        delegate?.tokenDidReceived(token)
                    } else if let errorMessage = response.errorMessage {
                        delegate?.recognitionFailure(message: errorMessage)
                    } else {
                        delegate?.recognitionFailure(message: "Ошибка запроса токена")
                    }
                })
                .store(in: &subscriptions)
        }
    }
}

// MARK: - Private extension

private extension PassportDataInteractor {
    func refreshToken(token: Token) {
        delegate?.recognitionStatus(message: "Обновление...")

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
                } else if let errorMessage = response.errorMessage {
                    delegate?.recognitionFailure(message: errorMessage)
                } else {
                    delegate?.recognitionFailure(message: "Ошибка за проса при обновлении токена")
                }
            })
            .store(in: &subscriptions)
    }
}
