//
//  AuthorizationModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

protocol AuthorizationModule: AnyObject {
    var coordinator: MainCoordinator? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol AuthorizationView: View {
}

protocol AuthorizationPresentation: AnyObject {
}

protocol AuthorizationInteraction: Interactor {
}

protocol AuthorizationInteractorDelegate: AnyObject {
}
