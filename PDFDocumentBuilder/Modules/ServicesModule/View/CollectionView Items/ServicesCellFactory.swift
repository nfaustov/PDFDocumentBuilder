//
//  ServicesCellFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 26.01.2022.
//

import UIKit
import CellFactory

final class ServicesCellFactory: CellFactory<UICollectionView> {
    override func makeCell(withModel model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        if let service = model as? Service {
            return configureCell(ServiceCell.self, with: service, for: indexPath)
        } else if let category = model as? ServicesCategory {
            return configureCell(CategoryCell.self, with: category, for: indexPath)
        } else {
            fatalError("Unknown model type.")
        }
    }
}
