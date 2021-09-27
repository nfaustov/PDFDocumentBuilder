//
//  HomePresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation

final class HomePresenter<V>: Presenter<V>, HomeModule where V: HomeView {
    weak var coordinator: HomeCoordinator?

    var didFinish: (() -> Void)?
}

// MARK: - HomePresentation

extension HomePresenter: HomePresentation {
}
