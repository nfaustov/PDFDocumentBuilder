//
//  PassportDataViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import UIKit

final class PassportDataViewController: UIViewController {
    typealias PresenterType = PassportDataPresentation
    var presenter: PresenterType!

    var passportImage: UIImage?

    private let statusLabel = UILabel()
    private let progressView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let confirmButton = UIButton(type: .custom)

//    private let passportInputView = PassportInputView(title: "Паспортные данные")
    private let residenceInputView = ResidenceInputView(title: "Место жительства")

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()

        guard let image = passportImage else { return }

        progressView.isHidden = false
        activityIndicatorView.startAnimating()
        presenter.recognizePassport(image: image)
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

//        view.addSubview(passportInputView)
        view.addSubview(residenceInputView)

        progressView.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        progressView.isHidden = true
        progressView.addSubview(activityIndicatorView)
        progressView.addSubview(statusLabel)
        view.addSubview(progressView)

        confirmButton.setTitle("Принять", for: .normal)
        confirmButton.setTitleColor(.label, for: .normal)
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.label.cgColor
        confirmButton.addTarget(self, action: #selector(confirmPassportData), for: .touchUpInside)
        view.addSubview(confirmButton)

        [residenceInputView, progressView, activityIndicatorView, statusLabel, confirmButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            residenceInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            residenceInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            residenceInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            residenceInputView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -50),
//            passportInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            passportInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            passportInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            passportInputView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -50),

            progressView.topAnchor.constraint(equalTo: view.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicatorView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),

            statusLabel.bottomAnchor.constraint(equalTo: progressView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            statusLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),

            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }

    @objc private func confirmPassportData() {
//        let passport = passportInputView.data
//        presenter.confirmPassportData(passport)
    }
}

// MARK: - PassportScanView

extension PassportDataViewController: PassportDataView {
    func updateStatus(title: String, color: UIColor) {
        statusLabel.text = title
        statusLabel.textColor = color
    }

    func fillInFields(recognizedData: PassportData) {
        activityIndicatorView.stopAnimating()
        progressView.isHidden = true

//        passportInputView.fillInFields(data: recognizedData)
    }
}
