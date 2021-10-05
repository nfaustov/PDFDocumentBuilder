//
//  BillCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import Foundation

protocol BillCell {
    associatedtype Model: Hashable
    static var reuseIdentifier: String { get }

    func configure(with: Model)
}
