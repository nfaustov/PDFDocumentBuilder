//
//  ServicesCellFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 26.01.2022.
//

import UIKit

final class ServicesCellFactory: CollectionViewCellFactory {
    override func makeCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        if let service = model as? Service {
            return configureCell(ServiceCell.self, with: service, for: indexPath)
        } else if let category = model as? ServicesCategory {
            return configureCell(CategoryCell.self, with: category, for: indexPath)
        } else {
            fatalError("Unknown model type.")
        }
    }
}
