//
//  SelectionSubscription.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.01.2022.
//

protocol SelectionSubscription: AnyObject {
    func routeToSelection(selectedServices: [Service], didFinish: @escaping ([Service], Bool) -> Void)
}
