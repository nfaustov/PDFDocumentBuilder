//
//  SelectionModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.01.2022.
//

protocol SelectionModule: AnyObject {
    var didFinish: (([Service], Bool) -> Void)? { get set }
}

protocol SelectionView: View {
}

protocol SelectionPresentation: AnyObject {
    func didFinish(with services: [Service], isRouteToBill: Bool)
}
