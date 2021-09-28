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

    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - PassportDataInteraction

extension PassportDataInteractor: PassportDataInteraction {
    func recognizePassport(data: String) {
        guard let tokenEntity = authorizationDatabase?.getToken() else { return }

        let token = Token(usingEntity: tokenEntity)

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
}
