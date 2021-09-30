//
//  ServicesPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 30.09.2021.
//

final class ServicesPresenter<V>: Presenter<V>, ServicesModule where V: ServicesView {
    weak var coordinator: HomeCoordinator?

    var didFinish: (() -> Void)?
}

// MARK: - ServicesPresentation

extension ServicesPresenter: ServicesPresentation {
}
