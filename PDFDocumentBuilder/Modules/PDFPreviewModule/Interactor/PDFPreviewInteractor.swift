//
//  PDFPreviewInteractor.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

final class PDFPreviewInteractor {
    typealias Delegate = PDFPreviewInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - PDFPreviewInteraction

extension PDFPreviewInteractor: PDFPreviewInteraction {
}
