//
//  AuthorizationPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

final class AuthorizationPresenter<V, I>: PresenterInteractor<V, I>, AuthorizationModule
where V: AuthorizationView, I: AuthorizationInteraction {
    weak var coordinator: MainCoordinator?

    var didFinish: (() -> Void)?
}

// MARK: - AuthorizationPresentation

extension AuthorizationPresenter: AuthorizationPresentation {
}

// MARK: - AuthorizationInteractorDelegate

extension AuthorizationPresenter: AuthorizationInteractorDelegate {
}
