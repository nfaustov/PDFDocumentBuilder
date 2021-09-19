//
//  ModulesFactory.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import UIKit

final class ModulesFactory: Modules {
    func pdfPreviewModule() -> (UIViewController, PDFPreviewModule) {
        let view = PDFPreviewViewController()
        let interactor = PDFPreviewInteractor()
        let presenter = PDFPreviewPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }
}
