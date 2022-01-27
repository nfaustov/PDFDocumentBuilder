//
//  ModulesFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import UIKit

final class ModulesFactory: Modules {
    private let dependencies: NetworkServiceDependencies & DatabaseServiceDependencies

    init(dependencies: NetworkServiceDependencies & DatabaseServiceDependencies) {
        self.dependencies = dependencies
    }

    func pdfPreviewModule(documentData: ContractBody) -> (UIViewController, PDFPreviewModule) {
        let view = PDFPreviewViewController()
        view.documentData = documentData
        let interactor = PDFPreviewInteractor()
        let presenter = PDFPreviewPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func homeModule() -> (UIViewController, HomeModule) {
        let view = HomeViewController()
        let interactor = HomeInteractor()
        interactor.counterService = dependencies.counterService
        interactor.authorizationService = dependencies.authorizationService
        interactor.tokenDatabase = dependencies.tokenDatabase
        let presenter = HomePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func passportDataModule(image: UIImage?) -> (UIViewController, PassportDataModule) {
        let view = PassportDataViewController()
        view.passportImage = image
        let interactor = PassportDataInteractor()
        interactor.recognitionService = dependencies.recognitionService
        interactor.authorizationService = dependencies.authorizationService
        interactor.tokenDatabase = dependencies.tokenDatabase
        let presenter = PassportDataPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func billModule(patient: Patient) -> (UIViewController, BillModule) {
        let view = BillViewController()
        view.patient = patient
        let presenter = BillPresenter(view: view)

        return (view, presenter)
    }

    func servicesModule() -> (UIViewController, ServicesModule) {
        let view = ServicesViewController()
        let presenter = ServicesPresenter(view: view)

        return (view, presenter)
    }

    func selectionModule(selectedServices: [Service]) -> (UIViewController, SelectionModule) {
        let view = SelectionViewController()
        view.services = selectedServices
        let presenter = SelectionPresenter(view: view)

        return (view, presenter)
    }
}
