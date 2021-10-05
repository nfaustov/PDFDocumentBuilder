//
//  BillCellFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit

final class BillCellFactory {
    private let collectionView: UICollectionView

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func getCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        if let service = model as? Service {
            return configureCell(BillServiceCell.self, with: service, for: indexPath)
        } else if let action = model as? ServiceCountAction {
            return configureCell(AddServiceCell.self, with: action, for: indexPath)
        } else if let total = model as? ServiceCountTotal {
            return configureCell(TotalCell.self, with: total, for: indexPath)
        } else {
            fatalError("Unknown model type.")
        }
    }

    private func configureCell<T>(
        _ cellType: T.Type,
        with model: T.Model,
        for indexPath: IndexPath
    ) -> T where T: BillCell {
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
