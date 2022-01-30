//
//  ServiceCountAction.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit

struct ServiceCountAction: Hashable {
    let title: String
    let icon: UIImage?

    static let addServiceAction = ServiceCountAction(
        title: "Добавить услуги",
        icon: UIImage(systemName: "chevron.right")
    )
}
