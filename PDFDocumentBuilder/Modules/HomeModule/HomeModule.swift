//
//  HomeModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

protocol HomeModule: AnyObject {
    var coordinator: MainCoordinator? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol HomeView: View {
}

protocol HomePresentation: AnyObject {
}
