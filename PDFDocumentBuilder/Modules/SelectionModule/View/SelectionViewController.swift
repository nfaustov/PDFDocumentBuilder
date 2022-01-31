//
//  SelectionViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.01.2022.
//

import UIKit

final class SelectionViewController: UITableViewController {
    typealias PresenterType = SelectionPresentation
    var presenter: PresenterType!

    enum Section: Int {
        case main
    }

    var services = [Service]()

    private let confirmationView = UIView()
    private let closeButton = UIButton(type: .custom)

    private var dataSource: UITableViewDiffableDataSource<Section, Service>!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
        snapshot()
    }

    private func configureHierarchy() {
        view.clipsToBounds = false
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.bounces = false
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 20, right: 0)

        view.addSubview(confirmationView)
        let button = UIButton(type: .custom)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.setTitle("Добавить в счёт", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        confirmationView.addSubview(button)
        confirmationView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        configureCloseButton()

        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: -40),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),

            button.centerXAnchor.constraint(equalTo: confirmationView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: confirmationView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: confirmationView.widthAnchor, multiplier: 0.6),
            button.heightAnchor.constraint(equalTo: confirmationView.heightAnchor, constant: -20)
        ])

        tableView.register(
            SelectionServiceCell.self,
            forCellReuseIdentifier: SelectionServiceCell.reuseIdentifier
        )
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, service in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SelectionServiceCell.reuseIdentifier,
                for: indexPath
            ) as? SelectionServiceCell else {
                fatalError("Unable to dequeue cell.")
            }

            cell.configure(with: service)

            return cell
        }
    }

    private func snapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Service>()
        snapshot.appendSections([.main])
        snapshot.appendItems(services, toSection: .main)
        dataSource.apply(snapshot)
    }

    private func configureCloseButton() {
        closeButton.backgroundColor = .systemBackground
        closeButton.layer.cornerRadius = 20
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        closeButton.layer.shadowRadius = 8
        closeButton.layer.shadowOpacity = 0.15
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            confirmationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            confirmationView.heightAnchor.constraint(equalToConstant: 80),
            confirmationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func confirm() {
        presenter.didFinish(with: services, routeToBill: true)
    }

    @objc private func close() {
        presenter.didFinish(with: services, routeToBill: false)
    }
}

// MARK: - UICollectionViewDelegate

extension SelectionViewController {
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.services.remove(at: indexPath.row)
            self.snapshot()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.bounds.height / 7
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension SelectionViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        CustomPrentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}

// MARK: - SelectionView

extension SelectionViewController: SelectionView { }
