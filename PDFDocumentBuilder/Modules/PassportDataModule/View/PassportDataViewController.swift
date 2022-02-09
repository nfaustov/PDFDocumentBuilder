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

    private let nameTextField = FloatingTextField(placeholder: "Имя")
    private let surnameTextField = FloatingTextField(placeholder: "Фамилия")
    private let patronymicTextField = FloatingTextField(placeholder: "Отчество")
    private let genderTextField = FloatingTextField(placeholder: "Пол")
    private let seriesNumberTextField = FloatingTextField(
        placeholder: "Серия и номер паспорта",
        keyboardType: .numberPad
    )
    private let birthdayTextField = FloatingTextField(placeholder: "Дата рождения")
    private let birthplaceTextField = FloatingTextField(placeholder: "Место рождения")
    private let issueDateTextField = FloatingTextField(placeholder: "Дата выдачи паспорта")
    private let authorityTextView = UITextView()

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

        configureStack()

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
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    private func configureStack() {
        let nameStack = UIStackView(arrangedSubviews: [surnameTextField, nameTextField])
        nameStack.axis = .horizontal
        nameStack.distribution = .fillEqually
        nameStack.spacing = 10

        let patronymicStack = UIStackView(arrangedSubviews: [patronymicTextField, genderTextField])
        patronymicStack.axis = .horizontal
        patronymicStack.distribution = .fillEqually
        patronymicStack.spacing = 10

        let birthStack = UIStackView(arrangedSubviews: [birthdayTextField, birthplaceTextField])
        birthStack.axis = .horizontal
        birthStack.distribution = .fillEqually
        birthStack.spacing = 10

        let passportStack = UIStackView(arrangedSubviews: [seriesNumberTextField, issueDateTextField])
        passportStack.axis = .horizontal
        passportStack.distribution = .fillEqually
        passportStack.spacing = 10

        let stack = UIStackView(
            arrangedSubviews: [
                nameStack,
                patronymicStack,
                birthStack,
                passportStack
            ]
        )
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        authorityTextView.layer.borderWidth = 0.5
        authorityTextView.layer.borderColor = UIColor.systemGray3.cgColor
        authorityTextView.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(authorityTextView)
        authorityTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            authorityTextView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            authorityTextView.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            authorityTextView.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            authorityTextView.heightAnchor.constraint(equalToConstant: 100)
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
            authority: authorityTextView.text ?? ""
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
        authorityTextView.text = recognizedData.authority
    }
}
