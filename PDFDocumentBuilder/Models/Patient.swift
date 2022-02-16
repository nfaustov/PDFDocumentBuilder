//
//  Patient.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 13.02.2022.
//

import Foundation

final class Patient {
    let id: UUID?
    let passport: PassportData
    let placeOfResidence: PlaceOfResidence

    var currentTreatmentPlan: TreatmentPlan? {
        treatmentPlans.first(where: { $0.state == .active })
    }

    var suspendedTreatmentPlans: [TreatmentPlan] {
        treatmentPlans.filter { $0.state != .active }
    }

    var name: String {
        passport.surname + " " + passport.name + " " + passport.patronymic
    }

    var residence: String {
        let items = [
            placeOfResidence.region,
            placeOfResidence.locality,
            placeOfResidence.streetAdress,
            placeOfResidence.house,
            placeOfResidence.appartment
        ]
        var residence = ""

        for item in items where !item.isEmpty {
            residence.append(item + ", ")
        }

        if residence.count > 1 { residence.removeLast(2) }

        return residence
    }

    private var treatmentPlans = [TreatmentPlan]()

    init(id: UUID? = UUID(), passport: PassportData, placeOfResidence: PlaceOfResidence) {
        self.id = id
        self.passport = passport
        self.placeOfResidence = placeOfResidence
    }

    func addTreatmentPlan(ofKind kind: TreatmentPlan.Kind, fromDate date: Date = Date()) {
        let treatmentPlan = TreatmentPlan(kind: kind, startingDate: date)

        for var plan in treatmentPlans {
           plan.suspend(fromDate: date)
        }

        treatmentPlans.append(treatmentPlan)
    }

    func removeTreatmentPlan(_ treatmentPlan: TreatmentPlan) {
        guard treatmentPlans.contains(treatmentPlan) else { return }

        treatmentPlans.removeAll(where: { $0 == treatmentPlan })
    }
}

struct PassportData: Decodable {
    enum CodingKeys: String, CodingKey {
        case name, surname, patronymic, gender, birthday, birthplace, authority
        case seriesNumber = "series_number"
        case issueDate = "issue_date"
    }

    let name: String
    let surname: String
    let patronymic: String
    let gender: String
    let seriesNumber: String
    let birthday: String
    let birthplace: String
    let issueDate: String
    let authority: String
}

struct PlaceOfResidence {
    let region: String
    let locality: String
    let streetAdress: String
    let house: String
    let appartment: String
}
