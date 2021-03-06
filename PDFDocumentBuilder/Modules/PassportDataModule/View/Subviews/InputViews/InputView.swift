//
//  InputView.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 12.02.2022.
//

import UIKit

class InputView: UIView {
    final private let title: String
    final private let header = UIView()

    final let inputStack = UIStackView()

    override var isFirstResponder: Bool {
        inputStack.arrangedSubviews.contains { subview in
            guard let subview = subview as? UIStackView else {
                return subview.isFirstResponder
            }

            return subview.arrangedSubviews.contains(where: { $0.isFirstResponder })
        }
    }

    init(title: String) {
        self.title = title
        super.init(frame: .zero)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        inputStack.axis = .vertical
        inputStack.spacing = 4
        inputStack.distribution = .fill
        addSubview(inputStack)
        inputStack.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        header.backgroundColor = .secondarySystemBackground
        header.addSubview(titleLabel)
        addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),

            inputStack.topAnchor.constraint(equalTo: header.bottomAnchor),
            inputStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            inputStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            inputStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
