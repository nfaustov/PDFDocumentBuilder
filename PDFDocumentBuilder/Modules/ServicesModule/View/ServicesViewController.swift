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

    var selectedServices = [Service]() {
        didSet {
            if selectedServices.isEmpty {
                UIView.animate(withDuration: 0.2) {
                    self.buttonViewBottomConstraint.constant = 60
                    self.view.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.buttonViewBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    private var selectedCategory: ServicesCategory?

    private let searchBar = UISearchBar()
    private let buttonView = UIView()

    private var buttonViewBottomConstraint = NSLayoutConstraint()

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private var servicesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Поиск услуг"

        configureHierarchy()
        configureDataSource()
        configureButtonView()
        performQuery(with: nil)
    }

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = .label
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
                    widthDimension: .absolute(140),
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
            let factory = ServicesCellFactory(forView: collectionView)
            let cell = factory.makeCell(withModel: itemIdentifier, for: indexPath)

            return cell
        }
    }

    private func configureButtonView() {
        buttonView.backgroundColor = .systemBackground
        view.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 10
        button.setTitle("Показать выбранные", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showSelected), for: .touchUpInside)
        buttonView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        buttonViewBottomConstraint = buttonView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 60
        )

        NSLayoutConstraint.activate([
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 60),
            buttonViewBottomConstraint,

            button.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: buttonView.widthAnchor, multiplier: 0.6),
            button.heightAnchor.constraint(equalTo: buttonView.heightAnchor, constant: -10)
        ])
    }

    private func performQuery(with filter: String?) {
        let services = priceList.filteredServices(withFilterText: filter, category: selectedCategory)
        let categories = priceList.allCategories

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.category, .service])
        snapshot.appendItems(services, toSection: .service)
        snapshot.appendItems(categories, toSection: .category)
        dataSource.apply(snapshot)
    }

    @objc private func showSelected() {
        presenter.showSelectedServices(selectedServices)
    }
}

// MARK: - UISearchBarDelegate

extension ServicesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        performQuery(with: nil)
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
            if category == selectedCategory {
                collectionView.deselectItem(at: indexPath, animated: true)
                selectedCategory = nil
            } else {
                selectedCategory = category
            }
            performQuery(with: searchBar.text)
        }
    }
}

// MARK: - ServicesView

extension ServicesViewController: ServicesView { }
