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

extension HomeCoordinator: ServicesSubscription {
    func routeToServices(passportData: PassportData) {
        let (viewController, module) = modules.servicesModule(passportData: passportData)
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
