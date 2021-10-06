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

    var documentData: ContractBody?

    private var pdfView: PDFView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        guard let documentData = documentData else { return }

        let pdfCreator = PDFCreator(body: documentData)
        pdfView = PDFView(frame: view.frame)
        pdfView.document = PDFDocument(data: pdfCreator.createContract())
        pdfView.autoScales = true
        view.addSubview(pdfView)
    }
}

// MARK: - PDFPreviewView

extension PDFPreviewViewController: PDFPreviewView {
}
