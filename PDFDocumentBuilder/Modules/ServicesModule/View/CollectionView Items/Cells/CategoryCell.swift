//
//  CategoryCell.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 26.01.2022.
//

import UIKit

final class CategoryCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "CategoryCell"

    let titleLabel = UILabel()

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .systemGreen : .systemGray6
            titleLabel.textColor = isSelected ? .white : .label
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.borderColor = UIColor.systemGreen.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: ServicesCategory) {
        isSelected = false
        titleLabel.text = category.title
    }
}
