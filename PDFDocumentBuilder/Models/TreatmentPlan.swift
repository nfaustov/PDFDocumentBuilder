//
//  TreatmentPlan.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 16.02.2022.
//

import Foundation

struct TreatmentPlan: Equatable {
    enum Kind: Int {
        case standard = 0
        case pregnancy = 1
    }

    enum State: Equatable {
        case active
        case upcoming
        case completed
    }

    private let calendar = Calendar.current

    private(set) var kind: Kind
    private let startingDate: Date
    private(set) var expirationDate: Date

    var state: State {
        if startingDate < Date() {
            return .upcoming
        } else {
            if expirationDate > Date() {
                return .completed
            } else {
                return .active
            }
        }
    }

    var daysToExpiration: Int {
        guard let numberOfDays = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: Date()),
            to: expirationDate
        ).day else {
            return 0
        }

        return numberOfDays
    }

    init(kind: Kind, startingDate: Date = Date()) {
        self.kind = kind
        self.startingDate = calendar.startOfDay(for: startingDate)
        let yearLaterDate = Date().addingTimeInterval(86_400 * 365)
        expirationDate = calendar.date(byAdding: .year, value: 1, to: self.startingDate) ?? yearLaterDate
    }

    mutating func upgrade(toKind newKind: Kind) {
        if newKind.rawValue > kind.rawValue {
            kind = newKind
        }
    }

    static func == (lhs: TreatmentPlan, rhs: TreatmentPlan) -> Bool {
        lhs.kind == rhs.kind && lhs.startingDate == rhs.startingDate
    }
}
