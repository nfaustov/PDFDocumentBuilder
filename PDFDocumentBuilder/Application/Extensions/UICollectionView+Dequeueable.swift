//
//  UICollectionView+Dequeueable.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 29.01.2022.
//

import UIKit

extension UICollectionView: Dequeueable {
    func dequeueReusableCell(with identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
