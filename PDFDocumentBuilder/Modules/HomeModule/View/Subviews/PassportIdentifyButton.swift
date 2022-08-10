//
//  PassportIdentifyButton.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 31.07.2022.
//

import UIKit

final class PassportIdentifyButton: UIView {
    enum PassportIdentifyType {
        case manualEnter
        case scan

        var title: String {
            switch self {
            case .manualEnter:
                return "Ввести данные вручную"
            case .scan:
                return "Сканировать паспорт"
            }
        }
    }

    private var action: (() -> Void)?
    private var infoLabel: UILabel?
    private var activityIndicator: UIActivityIndicatorView?

    init(type: PassportIdentifyType, action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)

        configureHierarchy(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeInfo(text: String) {
        infoLabel?.text = text
    }

    func toggleActivityIndicator() {
        guard let activityIndicator = activityIndicator else { return }

        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }

    private func configureHierarchy(type: PassportIdentifyType) {
        backgroundColor = .systemBackground

        let titleLabel = UILabel()
        titleLabel.text = type.title
        titleLabel.textColor = .label
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        if type == .scan {
            infoLabel = UILabel()
            infoLabel?.font = UIFont.systemFont(ofSize: 13)
            infoLabel?.textColor = .systemGray
            infoLabel?.translatesAutoresizingMaskIntoConstraints = false

            activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector (tap))
        addGestureRecognizer(tap)

        guard let infoLabel = infoLabel,
              let activityIndicator = activityIndicator else { return }

        addSubview(infoLabel)
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            activityIndicator.centerXAnchor.constraint(equalTo: infoLabel.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
        ])
    }

    @objc private func tap() {
        action?()
    }
}
