//
//  PDFPreviewModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import Foundation

protocol PDFPreviewModule: AnyObject {
    var coordinator: PDFPreviewCoordinator? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol PDFPreviewView: View {
    var documentData: Data? { get set }
}

protocol PDFPreviewPresentation: AnyObject {
    func buildContract(patient: Patient, services: [Service])
}

protocol PDFPreviewInteraction: Interactor {
}

protocol PDFPreviewInteractorDelegate: AnyObject {
}
