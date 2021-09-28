//
//  PassportDataModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

protocol PassportDataModule: AnyObject {
    var coordinator: HomeCoordinator? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol PassportDataView: View {
}

protocol PassportDataPresentation: AnyObject {
}

protocol PassportDataInteraction: Interactor {
}

protocol PassportDataInteractorDelegate: AnyObject {
}
