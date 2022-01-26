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
        case category
        case service
    }

    private let priceList = PriceList()
    private var selectedServices = [Service]() {
        didSet {
            rightBarButtonItem.setBadge(text: " ")
        }
    }
    private var selectedCategory: ServicesCategory?

    private let searchBar = UISearchBar()
    private var rightBarButtonItem: UIBarButtonItem!

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private var servicesCollectionView: UICollectionView!

    let searchTitle = "Поиск услуг"
    let selectedTitle = "Выбранные услуги"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = searchTitle

        let listImage = UIImage(systemName: "list.bullet")
        rightBarButtonItem = UIBarButtonItem(
            image: listImage,
            style: .plain,
            target: self,
            action: #selector(showSelected)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem

        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.didFinish(with: selectedServices)
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
        servicesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)

        searchBar.delegate = self
        servicesCollectionView.delegate = self
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section type.")
            }

            switch section {
            case .category:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                let layoutGroupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(135),
                    heightDimension: .absolute(70)
                )
                let layoutGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: layoutGroupSize,
                    subitems: [layoutItem]
                )
                layoutGroup.interItemSpacing = .fixed(10)
                layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
                layoutSection.orthogonalScrollingBehavior = .continuous

                return layoutSection
            case .service:
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
        }

        return layout
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: servicesCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            let factory = ServicesCellFactory(collectionView: collectionView)
            let cell = factory.makeCell(with: itemIdentifier, for: indexPath)

            return cell
        }
    }

    private func performQuery(with filter: String?) {
        navigationItem.title = searchTitle
        let services = priceList.filteredServices(with: filter)
        searchingSnapshot(services)
    }

    private func filterByCategory(_ category: ServicesCategory) {
        let services = priceList.categoryServices(category)
        searchingSnapshot(services)
        selectedCategory = category
    }

    @objc private func showSelected() {
        rightBarButtonItem.removeBadge()
        navigationItem.title = selectedTitle
        UIView.animate(
            withDuration: 0.2,
            animations: { self.searchBar.transform = CGAffineTransform(scaleX: 1, y: 0.01) },
            completion: { _ in self.searchBar.isHidden = true }
        )

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.category, .service])
        snapshot.appendItems(selectedServices, toSection: .service)
        dataSource.apply(snapshot)
    }

    private func searchingSnapshot(_ services: [Service]) {
        let categories = priceList.allCategories

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.category, .service])
        snapshot.appendItems(services, toSection: .service)
        snapshot.appendItems(categories, toSection: .category)
        dataSource.apply(snapshot)
    }
}

// MARK: - UISearchBarDelegate

extension ServicesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let indexPath = dataSource.indexPath(for: selectedCategory) {
            servicesCollectionView.deselectItem(at: indexPath, animated: false)
            selectedCategory = nil
        }
        performQuery(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDelegate

extension ServicesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }

        if let service = dataSource.itemIdentifier(for: indexPath) as? Service {
            selectedServices.append(service)
            collectionView.deselectItem(at: indexPath, animated: true)
        } else if let category = dataSource.itemIdentifier(for: indexPath) as? ServicesCategory {
            filterByCategory(category)
        }
    }
}

// MARK: - ServicesView

extension ServicesViewController: ServicesView { }
