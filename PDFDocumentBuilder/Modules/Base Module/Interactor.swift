//
//  Interactor.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

protocol Interactor: AnyObject {
    associatedtype Delegate
    var delegate: Delegate? { get set }
}
