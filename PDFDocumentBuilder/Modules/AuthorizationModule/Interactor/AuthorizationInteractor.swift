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

    var authorizationService: NetworkService?
    var authorizationDatabase: TokenDB?

    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - AuthorizationInteraction

extension AuthorizationInteractor: AuthorizationInteraction {
    func getToken() {
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
                }
            })
            .store(in: &subscriptions)
    }
}
