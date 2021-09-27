//
//  NetworkControllerProtocol.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation
import Combine

protocol NetworkControllerProtocol: AnyObject {
    typealias Headers = [String: Any]

    func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Decodable
}
