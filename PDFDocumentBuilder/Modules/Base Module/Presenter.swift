//
//  Presenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

class Presenter<V: View> {
    weak var view: V?

    init(view: V) {
        self.view = view

        if let presenter = self as? V.PresenterType {
            view.presenter = presenter
        } else {
            fatalError("Unrelated view type: \(V.self)")
        }
    }
}

class PresenterInteractor<V: View, I: Interactor>: Presenter<V> {
    var interactor: I

    init(view: V, interactor: I) {
        self.interactor = interactor
        super.init(view: view)

        if let presenter = self as? I.Delegate {
            interactor.delegate = presenter
        } else {
            fatalError("Unrelated interactor type: \(I.self)")
        }
    }
}
