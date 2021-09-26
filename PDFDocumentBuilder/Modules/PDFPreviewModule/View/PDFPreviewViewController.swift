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

        guard let data = documentData else { return }

        pdfView = PDFView(frame: view.frame)
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        view.addSubview(pdfView)
    }
}

// MARK: - PDFPreviewView

extension PDFPreviewViewController: PDFPreviewView {
}
