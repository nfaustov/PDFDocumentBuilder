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

    private let nameLabel = UILabel()
    private let clearButton = UIButton(type: .custom)
    private let servicesCountView = ServicesCountView()
    private let confirmButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    private func configureHierarchy() {
        view.backgroundColor = .secondarySystemBackground

        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .systemGray3
        nameLabel.text = patient?.name

        clearButton.setTitle("ОЧИСТИТЬ", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.backgroundColor = .systemBrown
        clearButton.layer.cornerRadius = 10
        clearButton.addTarget(self, action: #selector(clearServices), for: .touchUpInside)

        confirmButton.setTitle("Сформировать договор", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .systemRed
        confirmButton.layer.cornerRadius = 10
        confirmButton.addTarget(self, action: #selector(createContract), for: .touchUpInside)

        [nameLabel, clearButton, servicesCountView, confirmButton].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25),

            clearButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 150),
            clearButton.heightAnchor.constraint(equalToConstant: 30),

            servicesCountView.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 20),
            servicesCountView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            servicesCountView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            servicesCountView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func clearServices() {
        servicesCountView.services = []
    }

    @objc private func createContract() {
    }
}

// MARK: - BillView

extension BillViewController: BillView {
}
