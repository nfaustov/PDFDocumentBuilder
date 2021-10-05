//
//  ServiceCountTotal.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import Foundation

struct ServiceCountTotal: Hashable {
    var preliminaryTotal: Double
    var discount: Double

    static let placeholder = ServiceCountTotal(preliminaryTotal: 0, discount: 0)
}
