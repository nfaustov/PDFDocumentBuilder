//
//  ServicesModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 30.09.2021.
//

protocol ServicesModule: AnyObject {
    var coordinator: HomeCoordinator? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol ServicesView: View {
}

protocol ServicesPresentation: AnyObject {
}
