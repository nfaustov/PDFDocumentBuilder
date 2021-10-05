//
//  BillViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit

final class BillViewController: UIViewController {
    typealias PresenterType = BillPresentation
    var presenter: PresenterType!

    var patient: Patient?
}

// MARK: - BillView

extension BillViewController: BillView {
}
