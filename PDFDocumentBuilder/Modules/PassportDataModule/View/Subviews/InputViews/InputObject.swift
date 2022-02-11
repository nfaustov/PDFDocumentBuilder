//
//  InputObject.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 11.02.2022.
//

import Foundation

protocol InputModel { }

protocol InputObject: AnyObject {
    associatedtype Model: InputModel

    var title: String { get }
    var data: Model { get }
}
