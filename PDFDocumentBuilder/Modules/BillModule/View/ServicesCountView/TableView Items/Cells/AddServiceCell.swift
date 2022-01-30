//
//  AddServiceCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit
import CellFactory

class AddServiceCell: UITableViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "AddServiceCell"

    private let titleLabel = UILabel()
    private let disclosureImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.textColor = .systemRed
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(disclosureImageView)
        disclosureImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: disclosureImageView.leadingAnchor, constant: -10),

            disclosureImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            disclosureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            disclosureImageView.widthAnchor.constraint(equalToConstant: 16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ServiceCountAction) {
        titleLabel.text = model.title

        guard let icon = model.icon else { return }

        disclosureImageView.image = icon.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    }
}
