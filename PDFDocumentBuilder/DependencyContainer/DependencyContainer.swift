//
//  DependencyContainer.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

final class DependencyContainer: NetworkServiceDependencies, DatabaseServiceDependencies {
    // MARK: - NetworkService
    lazy var authorizationService: AuthService = AuthorizationService()

    // MARK: - DatabaseService
    lazy var authorizationDatabase: TokenDB = TokenDatabase()
}
