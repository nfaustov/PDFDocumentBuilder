//
//  SelectionViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 27.01.2022.
//

import UIKit

final class SelectionViewController: UIViewController {
    typealias PresenterType = SelectionPresentation
    var presenter: PresenterType!

    enum Section: Int {
        case main
    }

    var services = [Service]()

    var bottomConstraint = NSLayoutConstraint()

    private let confirmationView = UIView()

    private var dataSource: UITableViewDiffableDataSource<Section, Service>!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Выбранные услуги"

        configureHierarchy()
        configureDataSource()
        snapshot()
    }

    private func configureHierarchy() {
        view.backgroundColor = .secondarySystemBackground

        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)

        confirmationView.backgroundColor = .systemBackground
        view.addSubview(confirmationView)
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 10
        button.setTitle("Добавить в счёт", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        confirmationView.addSubview(button)
        confirmationView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            confirmationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmationView.heightAnchor.constraint(equalToConstant: 60),
            confirmationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            button.centerXAnchor.constraint(equalTo: confirmationView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: confirmationView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: confirmationView.widthAnchor, multiplier: 0.6),
            button.heightAnchor.constraint(equalTo: confirmationView.heightAnchor, constant: -10)
        ])

        tableView.register(
            SelectionServiceCell.self,
            forCellReuseIdentifier: SelectionServiceCell.reuseIdentifier
        )

        tableView.delegate = self
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

    @objc private func confirm() {
        presenter.didFinish(with: services)
    }
}

// MARK: - UICollectionViewDelegate

extension SelectionViewController: UITableViewDelegate {
    func tableView(
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.bounds.height / 7
    }
}

// MARK: - SelectionView

extension SelectionViewController: SelectionView {
}
