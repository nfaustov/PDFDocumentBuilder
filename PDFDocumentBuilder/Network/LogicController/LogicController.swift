//
//  LogicController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import Foundation
import Combine

protocol LogicController: AnyObject {
    var networkController: NetworkControllerProtocol { get }

    func getToken() -> AnyPublisher<TokenResponse, Error>
}
