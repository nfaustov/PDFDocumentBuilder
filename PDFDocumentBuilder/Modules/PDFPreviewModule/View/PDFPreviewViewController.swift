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
            name: "Николай",
            surname: "Фаустов",
            patronymic: "Игоревич",
            gender: "муж",
            seriesNumber: "4208 464812",
            birthday: "25.04.1988 г.",
            birthplace: "гор. Астрахань",
            issueDate: "31.05.2008 г.",
            authority: "Отделом УФМС России по Липецкой области в Советском округе гор. Липецка",
            authorityCode: "480-002"
        )
        let patient = Patient(id: UUID(), passport: passport)
        let service1 = Service(title: "ПЦР тест", price: 1950)
        let service2 = Service(title: "Прием гинеколога afhasfgasgasg adga'ga'gj'ajg agaidfka b", price: 1000)
        let contract = ContractBody(patient: patient, services: [service1, service2])
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
