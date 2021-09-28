//
//  PassportDataPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

final class PassportDataPresenter<V, I>: PresenterInteractor<V, I>, PassportDataModule
where V: PassportDataView, I: PassportDataInteraction {
    weak var coordinator: HomeCoordinator?

    var didFinish: (() -> Void)?
}

// MARK: - PassportScanPresentation

extension PassportDataPresenter: PassportDataPresentation {
}

// MARK: - PassportDataInteractionDelegate

extension PassportDataPresenter: PassportDataInteractorDelegate {
}
