//
//  PassportDataPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import UIKit

final class PassportDataPresenter<V, I>: PresenterInteractor<V, I>, PassportDataModule
where V: PassportDataView, I: PassportDataInteraction {
    weak var coordinator: BillSubscription?

    var didFinish: (() -> Void)?

    private var passportImageBase64String: String?
}

// MARK: - PassportScanPresentation

extension PassportDataPresenter: PassportDataPresentation {
    func recognizePassport(image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1)
        passportImageBase64String = imageData?.base64EncodedString()
        interactor.getToken()
    }

    func confirmPassportData(_ passportData: PassportData, placeOfResidence: PlaceOfResidence) {
        let patient = Patient(passport: passportData, placeOfResidence: placeOfResidence)
        coordinator?.routeToBill(patient: patient)
    }
}

// MARK: - PassportDataInteractionDelegate

extension PassportDataPresenter: PassportDataInteractorDelegate {
    func passportDidRecognized(_ passportData: PassportData) {
        view?.fillInFields(recognizedData: passportData)
    }

    func tokenDidReceived(_ token: Token) {
        guard let imageData = passportImageBase64String else { return }

        interactor.recognizePassport(data: imageData, token: token)
    }

    func recognitionFailure(message: String) {
        view?.updateStatus(title: message, color: .systemRed)
    }

    func recognitionStatus(message: String) {
        view?.updateStatus(title: message, color: .label)
    }
}
