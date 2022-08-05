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

    private var scanButton: PassportIdentifyButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scanButton.changeInfo(text: "")
        scanButton.isUserInteractionEnabled = false
        scanButton.alpha = 0.5
        scanButton.toggleActivityIndicator()
        presenter.getAgreementStatus()
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        scanButton = PassportIdentifyButton(type: .scan) { [weak self] in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self?.present(picker, animated: true)
        }

        let manualEnterButton = PassportIdentifyButton(type: .manualEnter) { [presenter] in
            presenter?.manualEnterPassportData()
        }

        for button in [scanButton, manualEnterButton].compactMap({ $0 }) {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.cornerRadius = 10
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scanButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            scanButton.heightAnchor.constraint(equalToConstant: 100),

            manualEnterButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 40),
            manualEnterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            manualEnterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            manualEnterButton.heightAnchor.constraint(equalToConstant: 100)
        ])
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

extension HomeViewController: HomeView {
    func updateStatus(initial: Int, current: Int) {
        scanButton.toggleActivityIndicator()
        scanButton.isUserInteractionEnabled = true
        scanButton.alpha = 1
        scanButton.changeInfo(text: "Доступно распознаваний: \(initial - current)/\(initial)")
    }

    func updateStatus(message: String) {
        scanButton.toggleActivityIndicator()
        scanButton.changeInfo(text: message)
    }
}
