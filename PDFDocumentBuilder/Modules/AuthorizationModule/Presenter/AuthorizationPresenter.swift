//
//  AuthorizationPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

final class AuthorizationPresenter<V, I>: PresenterInteractor<V, I>, AuthorizationModule
where V: AuthorizationView, I: AuthorizationInteraction {
    weak var coordinator: HomeSubscription?

    var didFinish: (() -> Void)?
}

// MARK: - AuthorizationPresentation

extension AuthorizationPresenter: AuthorizationPresentation {
    func getToken() {
        interactor.getToken()
    }
}

// MARK: - AuthorizationInteractorDelegate

extension AuthorizationPresenter: AuthorizationInteractorDelegate {
    func tokenDidRecieved() {
        view?.updateStatus(title: "Успешно!", color: .systemGreen)
        coordinator?.routeToHome()
    }

    func tokenFailure(message: String) {
        view?.updateStatus(title: message, color: .systemRed)
    }
}
