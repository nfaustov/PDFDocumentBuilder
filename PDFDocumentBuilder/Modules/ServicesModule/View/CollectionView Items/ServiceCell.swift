//
//  ServiceCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 04.10.2021.
//

import UIKit

final class ServiceCell: UICollectionViewCell {
    static let reuseIdentifier = "ServiceCell"

    let titleLabel = UILabel()
    let priceLabel = UILabel()

    func configure(with service: Service) {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        [titleLabel, priceLabel].forEach { label in
            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -12),

            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2)
        ])

        titleLabel.text = service.title
        priceLabel.text = "\(Int(service.price)) ₽"
    }
}
