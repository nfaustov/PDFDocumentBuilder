//
//  BillCellFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit

final class BillCellFactory: CellFactory {
     override func makeCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
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
}
