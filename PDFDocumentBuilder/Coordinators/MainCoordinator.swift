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
        pdfPreviewCoordinator()
    }

    private func pdfPreviewCoordinator() {
        let child = PDFPreviewCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
