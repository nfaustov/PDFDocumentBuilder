//
//  HomeViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.09.2021.
//

import UIKit

final class HomeViewController: UIViewController {
    typealias PresenterType = HomePresentation
    var presenter: PresenterType!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let scanButton = UIButton(type: .custom)
        scanButton.setTitle("Сканировать паспорт", for: .normal)
        scanButton.setTitleColor(.label, for: .normal)
        scanButton.layer.borderWidth = 1
        scanButton.layer.borderColor = UIColor.lightGray.cgColor
        scanButton.layer.cornerRadius = 10
        view.addSubview(scanButton)
        scanButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scanButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            scanButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            scanButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            scanButton.heightAnchor.constraint(equalToConstant: 160)
        ])

        scanButton.addTarget(self, action: #selector(scanPassport), for: .touchUpInside)
    }

    @objc private func scanPassport() {
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView {
}
