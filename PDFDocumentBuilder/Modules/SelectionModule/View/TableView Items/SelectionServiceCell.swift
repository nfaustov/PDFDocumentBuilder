//
//  SelectionServiceCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.01.2022.
//

import UIKit
import CellFactory

final class SelectionServiceCell: UITableViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "SelectionServiceCell"

    let titleLabel = UILabel()
    let priceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .systemBackground
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
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.78),

            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with service: Service) {
        titleLabel.text = service.title
        priceLabel.text = "\(Int(service.price)) ₽"
    }
}
