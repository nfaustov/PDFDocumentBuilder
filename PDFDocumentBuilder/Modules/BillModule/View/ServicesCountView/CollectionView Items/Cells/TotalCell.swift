//
//  TotalCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit

class TotalCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "TotalCell"

    private let preliminaryTitleLabel = UILabel()
    private let preliminaryLabel = UILabel()
    private let discountTitleLabel = UILabel()
    private let discountLabel = UILabel()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        preliminaryTitleLabel.text = "Промежуточный итог:"
        preliminaryTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        preliminaryLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        discountTitleLabel.text = "Скидка:"
        discountTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        discountLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        imageView.image = UIImage(systemName: "chevron.right")?.withTintColor(.label, renderingMode: .alwaysOriginal)

        [preliminaryTitleLabel, preliminaryLabel, discountTitleLabel, discountLabel, imageView].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            preliminaryTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            preliminaryTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            preliminaryTitleLabel.trailingAnchor.constraint(equalTo: preliminaryLabel.leadingAnchor, constant: -10),

            preliminaryLabel.topAnchor.constraint(equalTo: preliminaryTitleLabel.topAnchor),
            preliminaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            discountTitleLabel.topAnchor.constraint(equalTo: preliminaryTitleLabel.bottomAnchor, constant: 4),
            discountTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            discountTitleLabel.trailingAnchor.constraint(equalTo: discountLabel.leadingAnchor, constant: -10),

            discountLabel.topAnchor.constraint(equalTo: discountTitleLabel.topAnchor),
            discountLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -4),

            imageView.centerYAnchor.constraint(equalTo: discountLabel.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ServiceCountTotal) {
        preliminaryLabel.text = "\(model.preliminaryTotal) ₽"
        discountLabel.text = "\(model.discount) ₽"
    }
}
