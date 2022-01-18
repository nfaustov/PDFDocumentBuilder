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

    private let scrollView = UIScrollView()

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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
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

        view.addSubview(scrollView)
        scrollView.frame = view.bounds

        configureStack()

        progressView.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        progressView.isHidden = true
        progressView.addSubview(activityIndicatorView)
        progressView.addSubview(statusLabel)
        scrollView.addSubview(progressView)

        confirmButton.setTitle("Принять", for: .normal)
        confirmButton.setTitleColor(.label, for: .normal)
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.label.cgColor
        confirmButton.addTarget(self, action: #selector(confirmPassportData), for: .touchUpInside)
        scrollView.addSubview(confirmButton)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            activityIndicatorView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),

            statusLabel.bottomAnchor.constraint(equalTo: progressView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            statusLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),

            confirmButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor, constant: -20)
        ])
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
        stack.spacing = 25
        scrollView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -100)
        ])

        for textField in stack.arrangedSubviews {
            guard let textField = textField as? UITextField else { return }

            textField.delegate = self
        }

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

    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 2,
                right: 0
            )
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}

// MARK: - UITextFieldDelegate

extension PassportDataViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return false
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
