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

    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicatorView.startAnimating()
        presenter.getToken()
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            statusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - AuthorizationView

extension AuthorizationViewController: AuthorizationView {
    func updateStatus(title: String, color: UIColor) {
        activityIndicatorView.stopAnimating()
        statusLabel.text = title
        statusLabel.textColor = color
    }
}
