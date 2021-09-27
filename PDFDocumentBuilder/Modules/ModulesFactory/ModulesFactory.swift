//
//  ModulesFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import UIKit

final class ModulesFactory: Modules {
    private let dependencies: (NetworkServiceDependencies & DatabaseServiceDependencies)

    init(dependencies: (NetworkServiceDependencies & DatabaseServiceDependencies)) {
        self.dependencies = dependencies
    }

    func pdfPreviewModule() -> (UIViewController, PDFPreviewModule) {
        let view = PDFPreviewViewController()
        let interactor = PDFPreviewInteractor()
        let presenter = PDFPreviewPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func authorizationModule() -> (UIViewController, AuthorizationModule) {
        let view = AuthorizationViewController()
        let interactor = AuthorizationInteractor()
        interactor.authorizationService = dependencies.authorizationService
        let presenter = AuthorizationPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }
}
