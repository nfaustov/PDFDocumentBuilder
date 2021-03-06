//
//  ServicesPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 30.09.2021.
//

final class ServicesPresenter<V>: Presenter<V>, ServicesModule where V: ServicesView {
    var coordinator: SelectionSubscription?
    var didFinish: (([Service]) -> Void)?
}

// MARK: - ServicesPresentation

extension ServicesPresenter: ServicesPresentation {
    func didFinish(with services: [Service]) {
        didFinish?(services)
    }

    func showSelectedServices(_ selectedServices: [Service]) {
        coordinator?.routeToSelection(selectedServices: selectedServices) { services, routeToBill in
            self.view?.selectedServices = services
            if routeToBill { self.didFinish(with: services) }
        }
    }
}
