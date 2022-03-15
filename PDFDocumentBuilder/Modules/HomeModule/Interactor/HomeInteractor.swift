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
            .sink(receiveCompletion: { [delegate] completion in
                switch completion {
                case .failure(let error):
                    delegate?.agreementFailure(message: error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { [delegate] response in
                if let counter = response.detail?.first {
                    delegate?.agreementDidChecked(initial: counter.initial, current: counter.current)
                } else if let errorMessage = response.errorMessage {
                    delegate?.agreementFailure(message: errorMessage)
                } else {
                    delegate?.agreementFailure(message: "Ошибка запроса договора")
                }
            })
            .store(in: &subscriptions)
    }

    func getToken() {
        authorizationService?.getToken()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [delegate] completion in
                switch completion {
                case .failure(let error):
                    delegate?.agreementFailure(message: error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { [tokenDatabase, delegate] response in
                if let token = response.token {
                    tokenDatabase?.saveToken(token: token)
                    delegate?.tokenDidReceived(token)
                } else if let errorMessage = response.errorMessage {
                    delegate?.agreementFailure(message: errorMessage)
                } else {
                    delegate?.agreementFailure(message: "Ошибка запроса токена")
                }
            })
            .store(in: &subscriptions)
    }
}
