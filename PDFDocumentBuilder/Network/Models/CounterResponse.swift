//
//  CounterResponse.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 22.01.2022.
//

import Foundation

struct CounterResponse: Decodable {
    let detail: [Amount]?
    let errorMessage: String?
}

struct Amount: Decodable {
    enum CodingKeys: String, CodingKey {
        case initial = "initial_amount"
        case current = "current_amount"
    }

    let initial: Int
    let current: Int
}
