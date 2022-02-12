//
//  InputView.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 12.02.2022.
//

import UIKit

enum State {
    case expand
    case collapse

    var change: State {
        switch self {
        case .collapse: return .expand
        case .expand: return .collapse
        }
    }
}

class InputView: UIView {
    final private let header = UIView()
    final private let imageView = UIImageView(
        image: UIImage(systemName: "chevron.right")?.withTintColor(.label).withRenderingMode(.alwaysOriginal)
    )

    final let inputStack = UIStackView()

    final private let title: String

    final var state: State {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.setState()
                self.layoutIfNeeded()
            }
        }
    }

    init(title: String, state: State = .collapse) {
        self.title = title
        self.state = state
        super.init(frame: .zero)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        inputStack.axis = .vertical
        inputStack.spacing = 10
        inputStack.distribution = .fillEqually
        addSubview(inputStack)
        inputStack.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.translatesAutoresizingMaskIntoConstraints = false

        header.backgroundColor = .secondarySystemBackground
        header.addSubview(titleLabel)
        header.addSubview(imageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTap))
        header.addGestureRecognizer(tap)
        addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),

            imageView.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),

            inputStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            inputStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            inputStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            inputStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setState()
    }

    final private func setState() {
        switch state {
        case .expand:
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            inputStack.isHidden = false
        case .collapse:
            imageView.transform = .identity
            inputStack.isHidden = true
        }
    }

    @objc final private func headerTap() {
        state = state.change
    }
}
