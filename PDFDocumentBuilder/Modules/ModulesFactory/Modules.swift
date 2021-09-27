//
//  Modules.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import UIKit

protocol Modules {
    func pdfPreviewModule() -> (UIViewController, PDFPreviewModule)
    func authorizationModule() -> (UIViewController, AuthorizationModule)
}
