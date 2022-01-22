//
//  NetworkServiceDependencies.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

protocol NetworkServiceDependencies {
    var authorizationService: Authorization { get }
    var recognitionService: Recognition { get }
    var counterService: Counter { get }
}
