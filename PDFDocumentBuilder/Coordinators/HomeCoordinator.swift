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
        navigationController.pushViewController(viewController, animated: true)
    }
}
