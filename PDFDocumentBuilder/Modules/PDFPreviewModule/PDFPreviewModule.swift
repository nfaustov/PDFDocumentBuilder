//
//  PDFPreviewModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import Foundation

protocol PDFPreviewModule: AnyObject {
    var coordinator: HomeCoordinator? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol PDFPreviewView: View {
}

protocol PDFPreviewPresentation: AnyObject {
}

protocol PDFPreviewInteraction: Interactor {
}

protocol PDFPreviewInteractorDelegate: AnyObject {
}
