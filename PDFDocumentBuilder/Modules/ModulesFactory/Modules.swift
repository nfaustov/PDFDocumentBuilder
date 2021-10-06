//
//  Modules.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.09.2021.
//

import UIKit

protocol Modules {
    func pdfPreviewModule(documentData: ContractBody) -> (UIViewController, PDFPreviewModule)
    func authorizationModule() -> (UIViewController, AuthorizationModule)
    func homeModule() -> (UIViewController, HomeModule)
    func passportDataModule(image: UIImage?) -> (UIViewController, PassportDataModule)
    func servicesModule() -> (UIViewController, ServicesModule)
    func billModule(patient: Patient) -> (UIViewController, BillModule)
}
