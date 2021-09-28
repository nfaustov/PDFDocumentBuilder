//
//  HomePresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import UIKit

final class HomePresenter<V>: Presenter<V>, HomeModule where V: HomeView {
    weak var coordinator: PassportDataSubscription?

    var didFinish: (() -> Void)?
}

// MARK: - HomePresentation

extension HomePresenter: HomePresentation {
    func recognizePassportImage(_ image: UIImage) {
        coordinator?.routeToPassportData(withImage: image)
    }

    func manualEnterPassportData() {
        coordinator?.routeToPassportData(withImage: nil)
    }
}
