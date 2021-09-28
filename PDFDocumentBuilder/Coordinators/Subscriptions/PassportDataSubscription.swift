//
//  PassportDataSubscription.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

import UIKit

protocol PassportDataSubscription: AnyObject {
    func routeToPassportData(withImage image: UIImage?)
}
