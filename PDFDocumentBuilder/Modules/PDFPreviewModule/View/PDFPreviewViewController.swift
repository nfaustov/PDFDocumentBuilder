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
    private var pdfData: Data!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        guard let documentData = documentData else { return }

        let pdfCreator = PDFCreator(body: documentData)
        pdfData = pdfCreator.createContract()
        pdfView = PDFView(frame: view.bounds)
        pdfView.document = PDFDocument(data: pdfData)
        pdfView.autoScales = true
        view.addSubview(pdfView)

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, shareButton]
        navigationController?.setToolbarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setToolbarHidden(true, animated: true)
    }

    @objc private func shareAction() {
        guard let pdfData = pdfData else { return }

        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - PDFPreviewView

extension PDFPreviewViewController: PDFPreviewView {
}
