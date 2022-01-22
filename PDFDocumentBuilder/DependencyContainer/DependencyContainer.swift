//
//  DependencyContainer.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

final class DependencyContainer: NetworkServiceDependencies, DatabaseServiceDependencies {
    // MARK: - NetworkService
    lazy var authorizationService: Authorization = AuthorizationService()
    lazy var recognitionService: Recognition = RecognitionService()
    lazy var counterService: Counter = CounterService()

    // MARK: - DatabaseService
    lazy var authorizationDatabase: TokenDB = TokenDatabase()
}
