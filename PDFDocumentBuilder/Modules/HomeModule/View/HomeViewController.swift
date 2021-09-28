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

    var image: UIImage?

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

        let manualEnterButton = UIButton(type: .custom)
        manualEnterButton.setTitle("Ввести данные вручную", for: .normal)
        manualEnterButton.setTitleColor(.label, for: .normal)
        manualEnterButton.layer.borderWidth = 1
        manualEnterButton.layer.borderColor = UIColor.lightGray.cgColor
        manualEnterButton.layer.cornerRadius = 10
        view.addSubview(manualEnterButton)
        manualEnterButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scanButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            scanButton.heightAnchor.constraint(equalToConstant: 160),

            manualEnterButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 50),
            manualEnterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            manualEnterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            manualEnterButton.heightAnchor.constraint(equalToConstant: 160)
        ])

        scanButton.addTarget(self, action: #selector(scanPassport), for: .touchUpInside)
        manualEnterButton.addTarget(self, action: #selector(manualEnterPassportData), for: .touchUpInside)
    }

    @objc private func scanPassport() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func manualEnterPassportData() {
        presenter.manualEnterPassportData()
    }
}

// MARK: UIImagePickerControllerdelegate

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true, completion: nil)

        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        presenter.recognizePassportImage(pickedImage)
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView { }
