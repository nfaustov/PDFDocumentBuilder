//
//  MainCoordinator.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }

    func start() {
        authorizationCoordinator()
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
        }
    }

    private func authorizationCoordinator() {
        let child = AuthorizationCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}

extension MainCoordinator {
    func routeToHome() {
        let child = HomeCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
