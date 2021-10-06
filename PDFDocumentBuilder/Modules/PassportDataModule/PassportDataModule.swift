//
//  PassportDataModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import UIKit

protocol PassportDataModule: AnyObject {
    var coordinator: BillSubscription? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol PassportDataView: View {
    func updateStatus(title: String, color: UIColor)
    func fillInFields(recognizedData: PassportData)
}

protocol PassportDataPresentation: AnyObject {
    func recognizePassport(image: UIImage)
    func confirmPassportData(_ passportData: PassportData)
}

protocol PassportDataInteraction: Interactor {
    func recognizePassport(data: String, token: Token)
    func getToken()
}

protocol PassportDataInteractorDelegate: AnyObject {
    func passportDidRecognized(_ passportData: PassportData)
    func tokenDidReceived(_ token: Token)
    func recognitionFailure(message: String)
    func recognitionStatus(message: String)
}
