//
//  SelectionPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.01.2022.
//

import Foundation

final class SelectionPresenter<V>: Presenter<V>, SelectionModule where V: SelectionView {
    var didFinish: (([Service]) -> Void)?
}

// MARK: - SelectionPresentation

extension SelectionPresenter: SelectionPresentation {
    func didFinish(with services: [Service]) {
        didFinish?(services)
    }
}
