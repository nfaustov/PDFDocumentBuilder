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

    private let priceList = PriceList()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - ServicesView

extension ServicesViewController: ServicesView {
}
