//
//  SceneDelegate.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let dependencies: NetworkServiceDependencies & DatabaseServiceDependencies = DependencyContainer()
        let modules = ModulesFactory(dependencies: dependencies)
        let navigationController = UINavigationController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        coordinator = MainCoordinator(navigationController: navigationController, modules: modules)
        coordinator?.start()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let database = TokenDatabase()
        database.saveContext()
    }
}
