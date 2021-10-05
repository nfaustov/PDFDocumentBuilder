//
//  ServicesViewController.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 30.09.2021.
//

import UIKit

final class ServicesViewController: UIViewController {
    typealias PresenterType = ServicesPresentation
    var presenter: PresenterType!

    enum Section: Int {
        case main
    }

    var passportData: PassportData?

    private let priceList = PriceList()
    private var selectedServices = [Service]()

    private let searchBar = UISearchBar()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Service>!
    private var servicesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        view.addSubview(searchBar)

        let views = ["cv": collectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[cv]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[searchBar]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:[searchBar]-10-[cv]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(
            searchBar.topAnchor.constraint(
                equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                multiplier: 1
            )
        )
        NSLayoutConstraint.activate(constraints)
        servicesCollectionView = collectionView

        servicesCollectionView.register(ServiceCell.self, forCellWithReuseIdentifier: ServiceCell.reuseIdentifier)

        searchBar.delegate = self
        servicesCollectionView.delegate = self
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let layoutGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let layoutGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: layoutGroupSize,
                subitem: layoutItem,
                count: 6
            )
            layoutGroup.interItemSpacing = .fixed(10)
            layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.interGroupSpacing = 10

            return layoutSection
        }

        return layout
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Service>(
            collectionView: servicesCollectionView
        ) { collectionView, indexPath, service in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ServiceCell.reuseIdentifier,
                for: indexPath
            ) as? ServiceCell else {
                fatalError("Unable to dequeue cell.")
            }

            cell.configure(with: service)
            return cell
        }
    }

    private func performQuery(with filter: String?) {
        let services = priceList.filteredServices(with: filter)

        var snapshot = NSDiffableDataSourceSnapshot<Section, Service>()
        snapshot.appendSections([.main])
        snapshot.appendItems(services, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UISearchBarDelegate

extension ServicesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

// MARK: - UICollectionViewDelegate

extension ServicesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let service = dataSource.itemIdentifier(for: indexPath) else { return }

        selectedServices.append(service)
    }
}

// MARK: - ServicesView

extension ServicesViewController: ServicesView {
}
