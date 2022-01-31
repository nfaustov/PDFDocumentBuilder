//
//  ServicesCountView.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 05.10.2021.
//

import UIKit

final class ServicesCountView: UIView {
    enum Section: Int {
        case selected
        case addService
        case total
    }

    var services = [Service]() {
        didSet {
            var preliminaryTotal: Double

            if !services.isEmpty {
                preliminaryTotal = services.map { $0.price }.reduce(0, +)
            } else {
                preliminaryTotal = 0
            }

            let total = ServiceCountTotal(preliminaryTotal: preliminaryTotal, discount: discount)
            servicesTotal = [total]
            snapshot()
        }
    }
    var discount: Double = .zero {
        didSet {
            guard let total = servicesTotal.first else { return }

            let newTotal = ServiceCountTotal(preliminaryTotal: total.preliminaryTotal, discount: discount)
            servicesTotal = [newTotal]
            snapshot()
        }
    }

    private var addServiceAction: (() -> Void)?
    private var discountAction: (() -> Void)?

    private var serviceAction: [ServiceCountAction] = [.addServiceAction]
    private var servicesTotal: [ServiceCountTotal] = [.placeholder]

    private var dataSource: UITableViewDiffableDataSource<Section, AnyHashable>!
    private let tableView = UITableView(frame: .zero, style: .plain)

    private let servicesHeaderElementKind = "services-section-header"

    init(frame: CGRect, addServiceAction: @escaping () -> Void, discountAction: @escaping () -> Void) {
        super.init(frame: frame)
        self.addServiceAction = addServiceAction
        self.discountAction = discountAction

        backgroundColor = .systemBackground
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 15

        configureHierarchy()
        configureDataSource()
        snapshot()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func clearServices() {
        services.removeAll()
        snapshot()
    }

    private func configureHierarchy() {
        backgroundColor = .systemBackground

        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        tableView.register(BillServiceCell.self, forCellReuseIdentifier: BillServiceCell.reuseIdentifier)
        tableView.register(AddServiceCell.self, forCellReuseIdentifier: AddServiceCell.reuseIdentifier)
        tableView.register(TotalCell.self, forCellReuseIdentifier: TotalCell.reuseIdentifier)

        tableView.delegate = self
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, AnyHashable>(
            tableView: tableView
        ) { tableView, indexPath, item in
            let factory = BillCellFactory(forView: tableView)
            let cell = factory.makeCell(withModel: item, for: indexPath)
            cell.selectionStyle = .none

            return cell
        }
    }

    private func snapshot() {
        let service = Service(title: " ", price: 0)

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.selected, .addService, .total])
        snapshot.appendItems(services.isEmpty ? [service] : services, toSection: .selected)
        snapshot.appendItems(serviceAction, toSection: .addService)
        snapshot.appendItems(servicesTotal, toSection: .total)
        dataSource.apply(snapshot)
    }
}

// MARK: - UITableViewDelegate

extension ServicesCountView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }

        if dataSource.itemIdentifier(for: indexPath) as? ServiceCountAction != nil {
            addServiceAction?()
        } else if dataSource.itemIdentifier(for: indexPath) as? ServiceCountTotal != nil {
            discountAction?()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0 }

        switch section {
        case .selected: return 70
        case .addService: return 50
        case .total: return 85
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if Section(rawValue: section) == .selected {
            return 30
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        let titleLabel = UILabel()
        titleLabel.text = "Выбранные услуги"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let separator = UIView()
        separator.backgroundColor = .systemGray5
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            separator.widthAnchor.constraint(equalTo: view.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard Section(rawValue: indexPath.section) == .selected else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.services.remove(at: indexPath.row)
            self.snapshot()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }
}
