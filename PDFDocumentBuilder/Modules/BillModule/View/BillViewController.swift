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
    private let confirmButton = UIButton(type: .custom)
    private var servicesCountView: ServicesCountView!

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

        let servicesCountViewFrame = CGRect(
            x: 0,
            y: 225,
            width: view.bounds.width,
            height: view.bounds.height - 225
        )
        servicesCountView = ServicesCountView(frame: servicesCountViewFrame) { [presenter] in
            presenter?.addServices()
        }
        view.addSubview(servicesCountView)

        confirmButton.setTitle("Сформировать договор", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .systemRed
        confirmButton.layer.cornerRadius = 10
        confirmButton.addTarget(self, action: #selector(createContract), for: .touchUpInside)

        [nameLabel, clearButton, confirmButton].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 150),
            clearButton.heightAnchor.constraint(equalToConstant: 30),
            clearButton.bottomAnchor.constraint(equalTo: servicesCountView.topAnchor, constant: -20),

            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func clearServices() {
        servicesCountView.clearServices()
    }

    @objc private func createContract() {
        guard let patient = patient else { return }

        presenter.createContract(patient: patient, services: servicesCountView.services)
    }
}

// MARK: - BillView

extension BillViewController: BillView {
    func updateSelectedServices(_ services: [Service]) {
        servicesCountView.services.append(contentsOf: services)
    }
}
