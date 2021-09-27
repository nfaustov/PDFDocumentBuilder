//
//  AuthorizationModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//
import UIKit

protocol AuthorizationModule: AnyObject {
    var coordinator: AuthorizationCoordinator? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol AuthorizationView: View {
    func updateStatus(title: String, color: UIColor)
}

protocol AuthorizationPresentation: AnyObject {
    func getToken()
}

protocol AuthorizationInteraction: Interactor {
    func getToken()
}

protocol AuthorizationInteractorDelegate: AnyObject {
    func tokenDidRecieved()
    func tokenFailure(message: String)
}
