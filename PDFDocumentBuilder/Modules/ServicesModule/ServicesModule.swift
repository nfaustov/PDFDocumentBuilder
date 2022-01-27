//
//  ServicesModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 30.09.2021.
//

protocol ServicesModule: AnyObject {
    var coordinator: SelectionSubscription? { get set }
    var didFinish: (([Service]) -> Void)? { get set }
}

protocol ServicesView: View {
    var selectedServices: [Service] { get set }
}

protocol ServicesPresentation: AnyObject {
    func didFinish(with services: [Service])
    func showSelectedServices(_ selectedServices: [Service])
}
