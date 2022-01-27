//
//  SelectionViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.01.2022.
//

import UIKit

final class SelectionViewController: UIViewController {
    typealias PresenterType = SelectionPresentation
    var presenter: PresenterType!

    var services = [Service]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - SelectionView

extension SelectionViewController: SelectionView {
}
