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

    private var dataSource: UITableViewDiffableDataSource<Section, Service>!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
}

// MARK: - SelectionView

extension SelectionViewController: SelectionView {
}
