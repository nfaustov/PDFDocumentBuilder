//
//  Dequeueable.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 29.01.2022.
//

import Foundation

protocol Dequeueable {
    associatedtype Cell

    func dequeueReusableCell(with: String, for indexPath: IndexPath) -> Cell
}
