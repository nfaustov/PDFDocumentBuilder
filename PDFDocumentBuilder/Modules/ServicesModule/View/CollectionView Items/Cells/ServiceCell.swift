//
//  ServiceCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 04.10.2021.
//

import UIKit
import CellFactory

final class ServiceCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "ServiceCell"

    let titleLabel = UILabel()
    let priceLabel = UILabel()

    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.contentView.layer.borderWidth = self.isSelected ? 1 : 0
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
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
        isSelected = false
        titleLabel.text = service.title
        priceLabel.text = "\(Int(service.price)) ₽"
    }
}
