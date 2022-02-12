//
//  PassportInputView.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 10.02.2022.
//

import UIKit

final class PassportInputView: InputView {
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

    var data: PassportData {
        PassportData(
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
    }

    override init(title: String) {
        super.init(title: title)

        configureInputStack()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fillInFields(data: PassportData) {
        nameTextField.text = data.name
        surnameTextField.text = data.surname
        patronymicTextField.text = data.patronymic
        genderTextField.text = data.gender
        birthdayTextField.text = data.birthday
        birthplaceTextField.text = data.birthplace
        seriesNumberTextField.text = data.seriesNumber
        issueDateTextField.text = data.issueDate
        authorityTextView.text = data.authority
    }

    func configureInputStack() {
        let nameStack = UIStackView(arrangedSubviews: [surnameTextField, nameTextField])
        let patronymicStack = UIStackView(arrangedSubviews: [patronymicTextField, genderTextField])
        let birthStack = UIStackView(arrangedSubviews: [birthdayTextField, birthplaceTextField])
        let passportStack = UIStackView(arrangedSubviews: [seriesNumberTextField, issueDateTextField])

        [nameStack, patronymicStack, birthStack, passportStack].forEach { stack in
            stack.distribution = .fillEqually
            stack.spacing = 10
        }

        let label = UILabel()
        label.text = "Выдан:"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15)

        authorityTextView.layer.borderWidth = 0.5
        authorityTextView.layer.borderColor = UIColor.systemGray3.cgColor
        authorityTextView.font = UIFont.systemFont(ofSize: 17)
        authorityTextView.returnKeyType = .done
        authorityTextView.delegate = self

        let authorityStack = UIStackView(arrangedSubviews: [label, authorityTextView])
        authorityStack.spacing = 10

        [nameStack, patronymicStack, birthStack, passportStack, authorityStack].forEach { view in
            inputStack.addArrangedSubview(view)
        }
    }
}

// MARK: - UITextFieldDelegate

extension PassportInputView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()

            return false
        }

        return true
    }
}
