//
//  DateFormatterExtension.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 18.09.2021.
//

import Foundation

extension DateFormatter {
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")

        return dateFormatter
    }()
}
