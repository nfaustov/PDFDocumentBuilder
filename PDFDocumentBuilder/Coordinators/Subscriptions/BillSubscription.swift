//
//  BillSubscription.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

protocol BillSubscription: AnyObject {
    func routeToBill(patient: Patient)
}
