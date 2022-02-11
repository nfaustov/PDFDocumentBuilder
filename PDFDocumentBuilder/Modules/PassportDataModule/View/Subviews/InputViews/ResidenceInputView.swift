//
//  ResidenceInputView.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 10.02.2022.
//

import UIKit

final class ResidenceInputView: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        addSubview(regionTextField)
        regionTextField.translatesAutoresizingMaskIntoConstraints = false

        addSubview(localityTextField)
        localityTextField.translatesAutoresizingMaskIntoConstraints = false

        let adressStack = UIStackView(arrangedSubviews: [streetTextField, houseTextField, appartmentTextField])
        addSubview(adressStack)
        adressStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            regionTextField.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            regionTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            regionTextField.trailingAnchor.constraint(equalTo: trailingAnchor),

            localityTextField.topAnchor.constraint(equalTo: regionTextField.bottomAnchor, constant: 10),
            localityTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            localityTextField.trailingAnchor.constraint(equalTo: trailingAnchor),

            adressStack.topAnchor.constraint(equalTo: localityTextField.bottomAnchor, constant: 10),
            adressStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            adressStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
}
