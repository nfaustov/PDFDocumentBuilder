//
//  CellFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 26.01.2022.
//

import UIKit

protocol SelfConfiguredCell {
    associatedtype Model: Hashable
    static var reuseIdentifier: String { get }

    func configure(with: Model)
}

class CellFactory {
    final private let collectionView: UICollectionView

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func makeCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("This method must be overriden.")
    }

    final func configureCell<T: SelfConfiguredCell>(
        _ cellType: T.Type,
        with model: T.Model,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue cell.")
        }

        cell.configure(with: model)

        return cell
    }
}
