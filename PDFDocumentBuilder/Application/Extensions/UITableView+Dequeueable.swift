//
//  UITableView+Dequeueable.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 29.01.2022.
//

import UIKit

extension UITableView: Dequeueable {
    func dequeueReusableCell(with identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}
