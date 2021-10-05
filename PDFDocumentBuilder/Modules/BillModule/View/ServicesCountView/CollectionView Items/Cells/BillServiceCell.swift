//
//  BillServiceCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit

class BillServiceCell: UICollectionViewCell, BillCell {
    static let reuseIdentifier = "BillServiceCell"

    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let separator = UIView()

    func configure(with model: Service) {
        titleLabel.text = model.title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        priceLabel.text = "\(Int(model.price)) ₽"
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        separator.backgroundColor = .systemGray5

        [titleLabel, priceLabel, separator].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -10),

            priceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
