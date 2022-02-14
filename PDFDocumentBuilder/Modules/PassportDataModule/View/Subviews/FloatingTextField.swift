//
//  FloatingTextField.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.02.2022.
//

import UIKit

final class FloatingTextField: UIView {
    private let textField = UITextField()
    private let placeholderLabel = UILabel()

    private var placeholderTopConstraint = NSLayoutConstraint()

    private var isEmpty: Bool {
        textField.text?.isEmpty ?? true
    }

    private let keyboardType: UIKeyboardType

    private var placeholder: String

    private var isActive: Bool {
        textField.isFirstResponder || !isEmpty
    }

    override var isFirstResponder: Bool {
        textField.isFirstResponder
    }

    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
            changeTextFieldState()
        }
    }

    init(placeholder: String, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        super.init(frame: .zero)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.borderStyle = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.keyboardType = keyboardType
        textField.delegate = self
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textRecognizer), for: .allEditingEvents)

        placeholderLabel.text = placeholder
        placeholderLabel.textColor = .systemGray
        placeholderLabel.font = UIFont.systemFont(ofSize: 15)
        placeholderLabel.adjustsFontSizeToFitWidth = true
        textField.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        let underline = UIView()
        underline.backgroundColor = .systemGray3
        addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false

        placeholderTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),

            placeholderTopConstraint,
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),

            underline.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    @objc private func textRecognizer() {
        changeTextFieldState()
    }

    private func changeTextFieldState() {
        let placeholderX = placeholderLabel.frame.width * 0.3

        UIView.animate(withDuration: 0.15) {
            self.placeholderLabel.transform = self.isActive ?
                .init(scaleX: 0.7, y: 0.7).translatedBy(x: -placeholderX, y: 0) : .identity
            self.placeholderTopConstraint.constant = self.isActive ? 0 : 15
            self.layoutIfNeeded()
        }
    }
}

extension FloatingTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
