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
        case suspended(daysToExpiration: Int)
    }

    private let calendar = Calendar.current

    private(set) var kind: Kind
    private let startingDate: Date
    private(set) var expirationDate: Date
    private(set) var state: State

    init(kind: Kind, startingDate: Date = Date()) {
        self.kind = kind
        self.startingDate = calendar.startOfDay(for: startingDate)
        let yearLaterDate = Date().addingTimeInterval(86_400 * 365)
        expirationDate = calendar.date(byAdding: .year, value: 1, to: self.startingDate) ?? yearLaterDate
        state = .active
    }

    mutating func upgrade(toKind newKind: Kind) {
        if newKind.rawValue > kind.rawValue {
            kind = newKind
        }
    }

    mutating func suspend(fromDate date: Date) {
        switch state {
        case .active:
            let daysToExpiration = daysToExpiration(fromDate: date)
            state = .suspended(daysToExpiration: daysToExpiration)
        case .suspended:
            return
        }
    }

    mutating func activate(fromDate date: Date) {
        switch state {
        case .active:
            return
        case .suspended(let daysToExpiration):
            state = .active
            let remainingTimeInterval = TimeInterval(86_400 * daysToExpiration)
            expirationDate = date.addingTimeInterval(remainingTimeInterval)
        }
    }

    mutating func extend(forYears years: Int = 1) {
        let yearLaterDate = expirationDate.addingTimeInterval(TimeInterval(86_400 * years))
        expirationDate = calendar.date(byAdding: .year, value: years, to: expirationDate) ?? yearLaterDate
    }

    func daysToExpiration(fromDate date: Date = Date()) -> Int {
        guard let numberOfDays = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: date),
            to: expirationDate
        ).day else {
            return 0
        }

        return numberOfDays
    }

    static func == (lhs: TreatmentPlan, rhs: TreatmentPlan) -> Bool {
        lhs.kind == rhs.kind && lhs.startingDate == rhs.startingDate
    }
}
