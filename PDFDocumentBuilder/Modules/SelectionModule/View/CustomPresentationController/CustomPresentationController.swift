//
//  CustomPresentationController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 31.01.2022.
//

import UIKit

final class CustomPrentationController: UIPresentationController {
    private let darkView = UIView()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        darkView.backgroundColor = .black
        darkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        darkView.addGestureRecognizer(tap)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        return CGRect(
            origin: CGPoint(x: 0, y: containerView.frame.height * 1 / 5),
            size: CGSize(width: containerView.frame.width, height: containerView.frame.height * 4 / 5)
        )
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.darkView.alpha = 0
        }, completion: { _ in
            self.darkView.removeFromSuperview()
        })
    }

    override func presentationTransitionWillBegin() {
        darkView.alpha = 0
        containerView?.addSubview(darkView)
        presentedViewController.transitionCoordinator?.animate { _ in
            self.darkView.alpha = 0.4
        }
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        presentedView?.frame = frameOfPresentedViewInContainerView
        darkView.frame = containerView?.bounds ?? .zero
    }

    @objc private func dismiss() {
        if let presentedViewController = presentedViewController as? SelectionViewController {
            let services = presentedViewController.services
            presentedViewController.presenter.didFinish(with: services, isRouteToBill: false)
        }
    }
}
