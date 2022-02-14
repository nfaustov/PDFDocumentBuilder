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

    private let passportInputView = PassportInputView(title: "Паспортные данные")
    private let residenceInputView = ResidenceInputView(title: "Место жительства")

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardAppearance(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardAppearance(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        guard let image = passportImage else { return }

        progressView.isHidden = false
        activityIndicatorView.startAnimating()
        presenter.recognizePassport(image: image)
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let inputViewsStack = UIStackView(arrangedSubviews: [passportInputView, residenceInputView])
        inputViewsStack.axis = .vertical
        inputViewsStack.spacing = 10
        view.addSubview(inputViewsStack)

        progressView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
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

        [inputViewsStack, progressView, activityIndicatorView, statusLabel, confirmButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            inputViewsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputViewsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputViewsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputViewsStack.bottomAnchor.constraint(lessThanOrEqualTo: confirmButton.topAnchor, constant: -50),

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

    @objc private func keyboardAppearance(notification: Notification) {
        [passportInputView, residenceInputView].forEach { view in
            if notification.name == UIResponder.keyboardWillShowNotification {
                view.isHidden = !view.isFirstResponder
            } else {
                view.isHidden = false
            }
        }
    }

    @objc private func confirmPassportData() {
        let passport = passportInputView.data
        let residence = residenceInputView.data
        presenter.confirmPassportData(passport, placeOfResidence: residence)
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

        passportInputView.fillInFields(data: recognizedData)
    }
}
