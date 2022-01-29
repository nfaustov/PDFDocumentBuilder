//
//  CellFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 26.01.2022.
//

import UIKit

class CellFactory<V: Dequeueable> {
    final private let view: V

    init(forView view: V) {
        self.view = view
    }

    func makeCell(with model: AnyHashable, for indexPath: IndexPath) -> V.Cell {
        fatalError("This method must be overriden.")
    }

    final func configureCell<C: SelfConfiguredCell>(
        _ cellType: C.Type,
        with model: C.Model,
        for indexPath: IndexPath
    ) -> C {
        guard let cell = view.dequeueReusableCell(with: cellType.reuseIdentifier, for: indexPath) as? C else {
            fatalError("Unable to dequeue cell.")
        }

        cell.configure(with: model)

        return cell
    }
}
