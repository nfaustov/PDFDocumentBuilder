//
//  DatabaseServiceDependencies.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 22.01.2022.
//

protocol DatabaseServiceDependencies {
    var authorizationDatabase: TokenDB { get }
}
