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

    let contractLabel = UILabel()
    let scanButton = UIButton(type: .custom)
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.getAgreementStatus()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        scanButton.setTitle("Сканировать паспорт", for: .normal)

        let manualEnterButton = UIButton(type: .custom)
        manualEnterButton.setTitle("Ввести данные вручную", for: .normal)

        for button in [scanButton, manualEnterButton] {
            button.setTitleColor(.label, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.cornerRadius = 10
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
        }

        contractLabel.font = UIFont.systemFont(ofSize: 13)
        contractLabel.textColor = .systemGray
        activityIndicator.hidesWhenStopped = true

        scanButton.isEnabled = false
        scanButton.alpha = 0.5
        scanButton.addSubview(contractLabel)
        scanButton.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contractLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scanButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            scanButton.heightAnchor.constraint(equalToConstant: 160),

            contractLabel.centerXAnchor.constraint(equalTo: scanButton.centerXAnchor),
            contractLabel.bottomAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: -5),

            activityIndicator.centerXAnchor.constraint(equalTo: contractLabel.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contractLabel.centerYAnchor),

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

extension HomeViewController: HomeView {
    func updateStatus(initial: Int, current: Int) {
        activityIndicator.stopAnimating()
        scanButton.isEnabled = true
        scanButton.alpha = 1
        contractLabel.text = "Доступно распознаваний: \(initial - current)/\(initial)"
    }

    func updateStatus(message: String) {
        activityIndicator.stopAnimating()
        contractLabel.text = message
    }
}
