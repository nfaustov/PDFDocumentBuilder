//
//  PassportDataModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import UIKit

protocol PassportDataModule: AnyObject {
    var coordinator: HomeCoordinator? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol PassportDataView: View {
    func updateStatus(title: String, color: UIColor)
    func fillInFields(passportData: PassportData)
}

protocol PassportDataPresentation: AnyObject {
    func recognizePassport(image: UIImage)
}

protocol PassportDataInteraction: Interactor {
    func recognizePassport(data: String, token: Token)
    func verifyToken()
}

protocol PassportDataInteractorDelegate: AnyObject {
    func passportDidRecognized(_ passportData: PassportData)
    func tokenDidReceived(_ token: Token)
    func recognitionFailure(message: String)
    func recognitionStatus(message: String)
}
