//
//  ResidenceInputView.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 10.02.2022.
//

import UIKit

final class ResidenceInputView: InputView {
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

    override init(title: String) {
        super.init(title: title)

        configureInputStack()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureInputStack() {
        let adressStack = UIStackView(arrangedSubviews: [streetTextField, houseTextField, appartmentTextField])
        adressStack.spacing = 10

        inputStack.addArrangedSubview(regionTextField)
        inputStack.addArrangedSubview(localityTextField)
        inputStack.addArrangedSubview(adressStack)

        NSLayoutConstraint.activate([
            streetTextField.widthAnchor.constraint(equalTo: adressStack.widthAnchor, multiplier: 0.6),
            houseTextField.widthAnchor.constraint(equalTo: appartmentTextField.widthAnchor)
        ])
    }
}
