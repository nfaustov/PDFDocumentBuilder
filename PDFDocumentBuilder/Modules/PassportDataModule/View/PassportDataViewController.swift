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

    private let nameTextField = UITextField()
    private let surnameTextField = UITextField()
    private let patronymicTextField = UITextField()
    private let genderTextField = UITextField()
    private let seriesNumberTextField = UITextField()
    private let birthdayTextField = UITextField()
    private let birthplaceTextField = UITextField()
    private let issueDateTextField = UITextField()
    private let authorityTextField = UITextField()
    private let authorityCodeTextField = UITextField()

    private let statusLabel = UILabel()
    private let progressView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let image = passportImage {
            progressView.isHidden = false
            activityIndicatorView.startAnimating()
            presenter.recognizePassport(image: image)
        }
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        configureTextFields()

        let stack = UIStackView(
            arrangedSubviews: [
                nameTextField,
                surnameTextField,
                patronymicTextField,
                genderTextField,
                birthdayTextField,
                birthplaceTextField,
                seriesNumberTextField,
                issueDateTextField,
                authorityTextField,
                authorityCodeTextField
            ]
        )
        stack.axis = .vertical
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        progressView.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        progressView.isHidden = true
        progressView.addSubview(activityIndicatorView)
        progressView.addSubview(statusLabel)
        view.addSubview(progressView)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),

            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicatorView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),

            statusLabel.bottomAnchor.constraint(equalTo: progressView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            statusLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor)
        ])
    }

    private func configureTextFields() {
        nameTextField.placeholder = "Имя"
        surnameTextField.placeholder = "Фамилия"
        patronymicTextField.placeholder = "Отчество"
        genderTextField.placeholder = "Пол"
        birthdayTextField.placeholder = "Дата рождения"
        birthplaceTextField.placeholder = "Место рождения"
        seriesNumberTextField.placeholder = "Серия и номер паспорта"
        issueDateTextField.placeholder = "Дата выдачи паспорта"
        authorityTextField.placeholder = "Кем выдан паспорт"
        authorityCodeTextField.placeholder = "Код подразделения"
    }
}

// MARK: - PassportScanView

extension PassportDataViewController: PassportDataView {
    func updateStatus(title: String, color: UIColor) {
        statusLabel.text = title
        statusLabel.textColor = color
    }

    func fillInFields(passportData: PassportData) {
        activityIndicatorView.stopAnimating()
        progressView.isHidden = true

        nameTextField.text = passportData.name
        surnameTextField.text = passportData.surname
        patronymicTextField.text = passportData.patronymic
        genderTextField.text = passportData.gender
        birthdayTextField.text = passportData.birthday
        birthplaceTextField.text = passportData.birthplace
        seriesNumberTextField.text = passportData.seriesNumber
        issueDateTextField.text = passportData.issueDate
        authorityTextField.text = passportData.authority
        authorityCodeTextField.text = passportData.authorityCode
    }
}
