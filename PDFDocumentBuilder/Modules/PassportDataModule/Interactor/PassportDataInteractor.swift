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
    var authorizationService: Authorization?
    var tokenDatabase: TokenDB?

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
                    delegate?.recognitionFailure(message: "Ошибка запроса распознавания")
                }
            })
            .store(in: &subscriptions)
    }

    func getToken() {
        delegate?.recognitionStatus(message: "Авторизация...")

        if let tokenEntity = tokenDatabase?.getToken() {
            guard let access = tokenEntity.access, let refresh = tokenEntity.refresh else { return }

            let token = Token(access: access, refresh: refresh)
            delegate?.tokenDidReceived(token)
        } else {
            authorizationService?.getToken()
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Couldn't get token: \(error.localizedDescription)")
                    case .finished: break
                    }
                }, receiveValue: { [tokenDatabase, delegate] response in
                    if let token = response.token {
                        tokenDatabase?.saveToken(token: token)
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
