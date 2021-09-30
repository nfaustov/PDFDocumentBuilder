//
//  ServicesViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 30.09.2021.
//

import UIKit

final class ServicesViewController: UIViewController {
    typealias PresenterType = ServicesPresentation
    var presenter: PresenterType!

    var passportData: PassportData?
}

// MARK: - ServicesView

extension ServicesViewController: ServicesView {
}
