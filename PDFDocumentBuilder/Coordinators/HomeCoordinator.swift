//
//  HomeCoordinator.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import UIKit

final class HomeCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }

    func start() {
        let (viewController, module) = modules.homeModule()
        module.coordinator = self
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension HomeCoordinator: PassportDataSubscription {
    func routeToPassportData(withImage image: UIImage?) {
        let (viewController, module) = modules.passportDataModule(image: image)
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: BillSubscription {
    func routeToBill(patient: Patient) {
        let (viewController, module) = modules.billModule(patient: patient)
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: ServicesSubscription {
    func routeToServices(didFinish: @escaping ([Service]) -> Void) {
        let (viewController, module) = modules.servicesModule()
        module.coordinator = self
        module.didFinish = { [navigationController] services in
            navigationController.popViewController(animated: true)
            didFinish(services)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: PDFPreviewSubscription {
    func routeToPDFPreview(documentData: ContractBody) {
        let (viewController, module) = modules.pdfPreviewModule(documentData: documentData)
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: SelectionSubscription {
    func routeToSelection(selectedServices: [Service], didFinish: @escaping ([Service], Bool) -> Void) {
        let (viewController, module) = modules.selectionModule(selectedServices: selectedServices)
        module.didFinish = { services, isRouteToBill in
            viewController.dismiss(animated: true)
            didFinish(services, isRouteToBill)
        }
        viewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
        viewController.modalPresentationStyle = .custom
        navigationController.present(viewController, animated: true)
    }
}
