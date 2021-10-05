//
//  AddServiceCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit

class AddServiceCell: UICollectionViewCell, BillCell {
    static let reuseIdentifier = "AddServiceCell"

    private let titleLabel = UILabel()
    private let imageView = UIImageView()

    func configure(with model: ServiceCountAction) {
        titleLabel.text = model.title
        titleLabel.textColor = .systemRed
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        if let icon = model.icon {
            imageView.image = icon.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            contentView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -10),

            imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
}
