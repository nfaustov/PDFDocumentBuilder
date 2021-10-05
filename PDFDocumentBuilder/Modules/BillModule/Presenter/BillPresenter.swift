//
//  BillPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

final class BillPresenter<V>: Presenter<V>, BillModule where V: BillView {
    weak var coordinator: ServicesSubscription?

    var didFinish: (() -> Void)?
}

// MARK: - BillPresentation

extension BillPresenter: BillPresentation {
}
