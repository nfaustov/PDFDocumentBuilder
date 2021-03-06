//
//  BillPresenter.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

final class BillPresenter<V>: Presenter<V>, BillModule where V: BillView {
    weak var coordinator: (ServicesSubscription & PDFPreviewSubscription)?

    var didFinish: (() -> Void)?
}

// MARK: - BillPresentation

extension BillPresenter: BillPresentation {
    func addServices() {
        coordinator?.routeToServices { services in
            guard !services.isEmpty else { return }

            self.view?.updateSelectedServices(services)
        }
    }

    func createContract(patient: Patient, services: [Service], discount: Double) {
        let contractBody = ContractBody(patient: patient, services: services, discountRate: discount)
        coordinator?.routeToPDFPreview(documentData: contractBody)
    }
}
