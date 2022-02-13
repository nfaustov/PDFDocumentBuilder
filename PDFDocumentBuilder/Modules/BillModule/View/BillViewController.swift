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

    private var discount: Double = .zero {
        didSet {
            servicesCountView.discount = discount
        }
    }

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

        configureNameLabel()
        configureClearButton()

        let servicesCountViewFrame = CGRect(
            x: 0,
            y: 225,
            width: view.bounds.width,
            height: view.bounds.height - 225 - 75
        )
        servicesCountView = ServicesCountView(
            frame: servicesCountViewFrame,
            addServiceAction: {
                self.presenter.addServices()
            }, discountAction: {
                self.showDiscountAlert()
            }
        )
        view.addSubview(servicesCountView)

        configureConfirmButton()

        let confirmButtonView = UIView()
        confirmButtonView.backgroundColor = .systemBackground
        confirmButtonView.addSubview(confirmButton)

        [nameLabel, clearButton, confirmButtonView].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: clearButton.topAnchor, constant: -10),

            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 150),
            clearButton.heightAnchor.constraint(equalToConstant: 30),
            clearButton.bottomAnchor.constraint(equalTo: servicesCountView.topAnchor, constant: -20),

            confirmButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            confirmButtonView.heightAnchor.constraint(equalToConstant: 75),

            confirmButton.leadingAnchor.constraint(equalTo: confirmButtonView.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: confirmButtonView.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: confirmButtonView.bottomAnchor, constant: -25),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureNameLabel() {
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .systemGray3
        nameLabel.text = patient?.name
    }

    private func configureClearButton() {
        clearButton.setTitle("ОЧИСТИТЬ", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.backgroundColor = .systemBrown
        clearButton.layer.cornerRadius = 10
        clearButton.addTarget(self, action: #selector(clearServices), for: .touchUpInside)
    }

    private func configureConfirmButton() {
        confirmButton.setTitle("Сформировать договор", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .systemRed
        confirmButton.layer.cornerRadius = 10
        confirmButton.addTarget(self, action: #selector(createContract), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func showDiscountAlert() {
        let alertController = UIAlertController(
            title: "Добавление скидки",
            message: "Укажите размер скидки.",
            preferredStyle: .actionSheet
        )
        let threePercent = UIAlertAction(title: "3%", style: .default) { _ in
            alertController.dismiss(animated: true) {
                self.discount = 0.03
            }
        }
        let fivePercent = UIAlertAction(title: "5%", style: .default) { _ in
            alertController.dismiss(animated: true) {
                self.discount = 0.05
            }
        }
        let tenPercent = UIAlertAction(title: "10%", style: .default) { _ in
            alertController.dismiss(animated: true) {
                self.discount = 0.1
            }
        }
        alertController.addAction(tenPercent)
        alertController.addAction(fivePercent)
        alertController.addAction(threePercent)

        present(alertController, animated: true)
    }

    @objc private func clearServices() {
        servicesCountView.clearServices()
    }

    @objc private func createContract() {
        guard let patient = patient else { return }

        presenter.createContract(patient: patient, services: servicesCountView.services, discount: discount)
    }
}

// MARK: - BillView

extension BillViewController: BillView {
    func updateSelectedServices(_ services: [Service]) {
        for service in services {
            guard !servicesCountView.services.contains(service) else {
                continue
            }

            servicesCountView.services.append(service)
        }
    }
}
