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
    typealias Body = [String: Any]?

    func post<T>(type: T.Type, url: URL, headers: Headers, body: Body) -> AnyPublisher<T, Error> where T: Decodable
}
