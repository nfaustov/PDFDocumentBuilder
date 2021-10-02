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
    private let confirmButton = UIButton(type: .custom)

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

        progressView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        configureStack()
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

    private func configureStack() {
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

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20)
        ])
    }

    @objc private func confirmPassportData() {
        let passport = PassportData(
            name: nameTextField.text ?? "",
            surname: surnameTextField.text ?? "",
            patronymic: patronymicTextField.text ?? "",
            gender: genderTextField.text ?? "",
            seriesNumber: seriesNumberTextField.text ?? "",
            birthday: birthdayTextField.text ?? "",
            birthplace: birthplaceTextField.text ?? "",
            issueDate: issueDateTextField.text ?? "",
            authority: authorityTextField.text ?? "",
            authorityCode: authorityCodeTextField.text ?? ""
        )

        presenter.confirmPassportData(passport)
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

        nameTextField.text = recognizedData.name
        surnameTextField.text = recognizedData.surname
        patronymicTextField.text = recognizedData.patronymic
        genderTextField.text = recognizedData.gender
        birthdayTextField.text = recognizedData.birthday
        birthplaceTextField.text = recognizedData.birthplace
        seriesNumberTextField.text = recognizedData.seriesNumber
        issueDateTextField.text = recognizedData.issueDate
        authorityTextField.text = recognizedData.authority
        authorityCodeTextField.text = recognizedData.authorityCode
    }
}
