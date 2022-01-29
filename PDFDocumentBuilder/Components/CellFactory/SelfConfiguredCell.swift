//
//  SelfConfiguredCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 29.01.2022.
//

protocol SelfConfiguredCell {
    associatedtype Model: Hashable

    static var reuseIdentifier: String { get }

    func configure(with: Model)
}
