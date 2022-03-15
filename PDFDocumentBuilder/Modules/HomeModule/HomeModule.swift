//
//  HomeModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import UIKit

protocol HomeModule: AnyObject {
    var coordinator: PassportDataSubscription? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol HomeView: View {
    func updateStatus(initial: Int, current: Int)
    func updateStatus(message: String)
}

protocol HomePresentation: AnyObject {
    func getAgreementStatus()
    func recognizePassportImage(_ image: UIImage)
    func manualEnterPassportData()
}

protocol HomeInteraction: Interactor {
    func checkAgreement(token: Token)
    func getToken()
}

protocol HomeInteractorDelegate: AnyObject {
    func agreementDidChecked(initial: Int, current: Int)
    func agreementFailure(message: String)
    func tokenDidReceived(_ token: Token)
}
