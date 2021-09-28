//
//  PassportDataInteractor.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import Foundation

final class PassportDataInteractor {
    typealias Delegate = PassportDataInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - PassportDataInteraction

extension PassportDataInteractor: PassportDataInteraction {
    func recognizePassport(data: String) {
    }
}
