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
        coordinator?.routeToServices()
    }

    func createContract(patient: Patient, services: [Service]) {
        let contractBody = ContractBody(patient: patient, services: services)
        coordinator?.routeToPDFPreview(documentData: contractBody)
    }
}
