//
//  HomePresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import UIKit

final class HomePresenter<V, I>: PresenterInteractor<V, I>, HomeModule where V: HomeView, I: HomeInteraction {
    weak var coordinator: PassportDataSubscription?

    var didFinish: (() -> Void)?
}

// MARK: - HomePresentation

extension HomePresenter: HomePresentation {
    func getAgreementStatus() {
        interactor.getToken()
    }

    func recognizePassportImage(_ image: UIImage) {
        coordinator?.routeToPassportData(withImage: image)
    }

    func manualEnterPassportData() {
        coordinator?.routeToPassportData(withImage: nil)
    }
}

// MARK: - HomeInteractorDelegate

extension HomePresenter: HomeInteractorDelegate {
    func agreementDidChecked(initial: Int, current: Int) {
        view?.updateStatus(initial: initial, current: current)
    }

    func tokenDidReceived(_ token: Token) {
        interactor.checkAgreement(token: token)
    }
}
