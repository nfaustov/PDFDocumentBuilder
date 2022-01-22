//
//  Counter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 22.01.2022.
//

import Foundation
import Combine

protocol Counter: AnyObject {
    var networkController: NetworkControllerProtocol { get }

    func countServices(token: String) -> AnyPublisher<CounterResponse, Error>
}
