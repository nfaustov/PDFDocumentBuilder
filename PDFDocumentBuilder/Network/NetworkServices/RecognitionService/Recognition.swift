//
//  Recognition.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import Foundation
import Combine

protocol Recognition: AnyObject {
    var networkController: NetworkControllerProtocol { get }

    func recognizePassport(data: String, token: String) -> AnyPublisher<PassportDataResponse, Error>
}
