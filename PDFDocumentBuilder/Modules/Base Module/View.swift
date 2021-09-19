//
//  View.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

protocol View: AnyObject {
    associatedtype PresenterType
    var presenter: PresenterType! { get set }
}
