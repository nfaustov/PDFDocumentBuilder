//
//  PassportDataPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import UIKit

final class PassportDataPresenter<V, I>: PresenterInteractor<V, I>, PassportDataModule
where V: PassportDataView, I: PassportDataInteraction {
    weak var coordinator: HomeCoordinator?

    var didFinish: (() -> Void)?
}

// MARK: - PassportScanPresentation

extension PassportDataPresenter: PassportDataPresentation {
    func recognizePassport(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            print("Couldn't get jpeg data from image")
            return
        }

        let imageDataBase64String = imageData.base64EncodedString()
        interactor.recognizePassport(data: imageDataBase64String)
    }
}

// MARK: - PassportDataInteractionDelegate

extension PassportDataPresenter: PassportDataInteractorDelegate {
    func passportDidRecognized(_ passportData: PassportData) {
        view?.fillInFields(passportData: passportData)
    }

    func recognitionFailure(message: String) {
        view?.updateStatus(title: message, color: .systemRed)
    }
}
