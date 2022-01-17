//
//  UIBarButtonItem+Badge.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 17.01.2022.
//

import UIKit

private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let badge: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return badge as? CAShapeLayer
        } else {
            return nil
        }
    }

    func setBadge(
        text: String?,
        color: UIColor = .systemRed,
        fontSize: CGFloat = 11
    ) {
        badgeLayer?.removeFromSuperlayer()

        guard let text = text, !text.isEmpty else {
            return
        }

        addBadge(text: text, color: color, fontSize: fontSize)
    }

    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }

    private func addBadge(
        text: String,
        color: UIColor = .systemRed,
        fontSize: CGFloat = 11
    ) {
        guard let view = self.value(forKey: "view") as? UIView else { return }

        let font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)

        let badgeSize = text == " " ? CGSize(width: 8, height: 10) : text.size(withAttributes: [.font: font])

        let height = badgeSize.height
        var width = badgeSize.width + 2

        if width < height {
            width = height
        }

        let badgeX = view.frame.width - width

        let badgeFrame = CGRect(origin: CGPoint(x: badgeX, y: 3), size: CGSize(width: width, height: height))

        let badge = CAShapeLayer()
        badge.drawRoundedRect(badgeFrame, color: color)
        view.layer.addSublayer(badge)

        let label = CATextLayer()
        label.alignmentMode = .center
        label.string = "\(text)"
        label.font = font
        label.fontSize = fontSize
        label.frame = badgeFrame
        label.foregroundColor = UIColor.white.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)

        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        badge.zPosition = 1000
    }
}

extension CAShapeLayer {
    func drawRoundedRect(_ rect: CGRect, color: UIColor) {
        fillColor = color.cgColor
        strokeColor = color.cgColor
        path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
    }
}
