//
//  PDFPreviewPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

final class PDFPreviewPresenter<V, I>: PresenterInteractor<V, I>, PDFPreviewModule where V: PDFPreviewView, I: PDFPreviewInteraction {
    weak var coordinator: PDFPreviewCoordinator?

    var didFinish: (() -> Void)?
}

// MARK: - PDFPreviewPresentation

extension PDFPreviewPresenter: PDFPreviewPresentation {
}

// MARK: - PDFPreviewInteractorDelegate

extension PDFPreviewPresenter: PDFPreviewInteractorDelegate {
}
