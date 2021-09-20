//
//  PDFPreviewViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.07.2021.
//

import PDFKit

final class PDFPreviewViewController: UIViewController {
    typealias PresenterType = PDFPreviewPresentation
    var presenter: PresenterType!

    var documentData: Data?
    private var pdfView: PDFView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

//        if let data = documentData {
//            pdfView.document = PDFDocument(data: data)
//            pdfView.autoScales = true
//        }
        let passport = PassportData(
            name: "",
            surname: "",
            patronymic: "",
            gender: "",
            seriesNumber: "",
            birthday: "",
            birthplace: "",
            issueDate: "",
            authority: "",
            authorityCode: ""
        )
        let patient = Patient(id: UUID(), passport: passport)
        let service = Service(title: "ПЦР тест", price: 1950)
        let contract = ContractBody(patient: patient, services: [service])
        let pdf = PDFCreator(body: contract)
        pdfView = PDFView(frame: view.frame)
        pdfView.document = PDFDocument(data: pdf.createContract())
        pdfView.autoScales = true
        view.addSubview(pdfView)
    }
}

// MARK: - PDFPreviewView

extension PDFPreviewViewController: PDFPreviewView {
}
