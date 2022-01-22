//
//  HomeInteractor.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 22.01.2022.
//

import Foundation
import Combine

final class HomeInteractor {
    typealias Delegate = HomeInteractorDelegate
    weak var delegate: Delegate?

    var authorizationService: Authorization?
    var counterService: Counter?
    var tokenDatabase: TokenDB?

    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - HomeInteraction

extension HomeInteractor: HomeInteraction {
    func checkAgreement(token: Token) {
        counterService?.countServices(token: token.access)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Couldn't count services: \(error.localizedDescription)")
                case .finished: break
                }
            }, receiveValue: { [delegate] response in
                if let counter = response.detail?.first {
                    delegate?.agreementDidChecked(initial: counter.initial, current: counter.current)
                } else if let errorMessage = response.errorMessage {
                    delegate?.agreementCheckingFailed(message: errorMessage)
                } else {
                    delegate?.agreementCheckingFailed(message: "Статус договора неизвестен")
                }
            })
            .store(in: &subscriptions)
    }

    func getToken() {
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
                }, receiveValue: { [delegate] response in
                    if let token = response.token {
                        delegate?.tokenDidReceived(token)
                    } else if let errorMessage = response.errorMessage {
                        delegate?.agreementCheckingFailed(message: errorMessage)
                    } else {
                        delegate?.agreementCheckingFailed(message: "Ошибка запроса токена")
                    }
                })
                .store(in: &subscriptions)
        }
    }
}
