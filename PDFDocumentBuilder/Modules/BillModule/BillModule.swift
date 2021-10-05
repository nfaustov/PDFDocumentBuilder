//
//  BillModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

protocol BillModule: AnyObject {
    var coordinator: ServicesSubscription? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol BillView: View {
}

protocol BillPresentation: AnyObject {
    func addServices()
}