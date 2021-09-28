//
//  HomeModule.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import UIKit

protocol HomeModule: AnyObject {
    var coordinator: PassportDataSubscription? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol HomeView: View { }

protocol HomePresentation: AnyObject {
    func recognizePassportImage(_ image: UIImage)
    func manualEnterPassportData()
}
