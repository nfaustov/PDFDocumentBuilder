//
//  AuthorizationInteractor.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//
import Foundation

final class AuthorizationInteractor {
    typealias Delegate = AuthorizationInteractorDelegate
    weak var delegate: Delegate?

    var authorizationService: NetworkService?
}

// MARK: - AuthorizationInteraction

extension AuthorizationInteractor: AuthorizationInteraction {
    func getToken() {
        authorizationService?.getToken()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Couldn't get token: \(error)")
                case .finished: break
                }
            }, receiveValue: { [delegate] response in
                if let token = response.token {
                    delegate?.tokenDidRecieved()
                } else if let errorMessage = response.errorMessage {
                    delegate?.tokenFailure(message: errorMessage)
                }
            })
            .cancel()
    }
}
