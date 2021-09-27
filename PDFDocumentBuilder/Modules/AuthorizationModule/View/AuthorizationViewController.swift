//
//  AuthorizationViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import UIKit

final class AuthorizationViewController: UIViewController {
    typealias PresenterType = AuthorizationPresentation
    var presenter: PresenterType!
}

// MARK: - AuthorizationView

extension AuthorizationViewController: AuthorizationView {
}
