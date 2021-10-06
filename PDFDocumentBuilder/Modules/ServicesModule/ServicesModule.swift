//
//  ServicesModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 30.09.2021.
//

protocol ServicesModule: AnyObject {
    var didFinish: (([Service]) -> Void)? { get set }
}

protocol ServicesView: View {
}

protocol ServicesPresentation: AnyObject {
    func didFinish(with services: [Service])
}
