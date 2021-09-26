//
//  PDFPreviewPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import Foundation

final class PDFPreviewPresenter<V, I>: PresenterInteractor<V, I>, PDFPreviewModule
where V: PDFPreviewView, I: PDFPreviewInteraction {
    weak var coordinator: PDFPreviewCoordinator?

    var didFinish: (() -> Void)?
}

// MARK: - PDFPreviewPresentation

extension PDFPreviewPresenter: PDFPreviewPresentation {
    func buildContract(patient: Patient, services: [Service]) {
        let contract = ContractBody(patient: patient, services: services)
        let pdf = PDFCreator(body: contract)

        view?.documentData = pdf.createContract()
    }
}

// MARK: - PDFPreviewInteractorDelegate

extension PDFPreviewPresenter: PDFPreviewInteractorDelegate {
}
