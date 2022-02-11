//
//  ResidenceInputView.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 10.02.2022.
//

import UIKit

final class ResidenceInputView: UIView, InputObject {
    private let regionTextField = FloatingTextField(placeholder: "Регион")
    private let localityTextField = FloatingTextField(placeholder: "Населенный пункт")
    private let streetTextField = FloatingTextField(placeholder: "Улица")
    private let houseTextField = FloatingTextField(placeholder: "Дом")
    private let appartmentTextField = FloatingTextField(placeholder: "Квартира")

    var data: PlaceOfResidence {
        PlaceOfResidence(
            region: regionTextField.text ?? "",
            locality: localityTextField.text ?? "",
            streetAdress: streetTextField.text ?? "",
            house: houseTextField.text ?? "",
            appartment: appartmentTextField.text ?? ""
        )
    }

    let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        let adressStack = UIStackView(arrangedSubviews: [streetTextField, houseTextField, appartmentTextField])
        adressStack.spacing = 10

        let stack = UIStackView(arrangedSubviews: [regionTextField, localityTextField, adressStack])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            streetTextField.widthAnchor.constraint(equalTo: adressStack.widthAnchor, multiplier: 0.6),
            houseTextField.widthAnchor.constraint(equalTo: appartmentTextField.widthAnchor)
        ])
    }
}
