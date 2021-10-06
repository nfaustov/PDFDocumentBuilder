//
//  PDFPreviewSubscription.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 06.10.2021.
//

protocol PDFPreviewSubscription: AnyObject {
    func routeToPDFPreview(documentData: ContractBody)
}
