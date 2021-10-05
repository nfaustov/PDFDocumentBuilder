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

    var services = [Service(title: " ", price: 0)] {
        didSet {
            let preliminaryTotal = services.map { $0.price }.reduce(0, +)
            let total = ServiceCountTotal(preliminaryTotal: preliminaryTotal, discount: discount)
            servicesTotal = [total]
        }
    }

    private var discount: Double = .zero

    private var addServiceAction: [ServiceCountAction] = [.addServiceAction]
    private var servicesTotal: [ServiceCountTotal] = [.placeholder]

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private var collectionView: UICollectionView!

    private let servicesHeaderElementKind = "services-section-header"

    init() {
        super.init(frame: .zero)

        backgroundColor = .systemBackground
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 15

        configureHierarchy()
        configureDataSource()
        configureSupplementaryViews()
        initialSnapshot()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        backgroundColor = .systemBackground

        collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        collectionView.delegate = self

        collectionView.register(BillServiceCell.self, forCellWithReuseIdentifier: BillServiceCell.reuseIdentifier)
        collectionView.register(AddServiceCell.self, forCellWithReuseIdentifier: AddServiceCell.reuseIdentifier)
        collectionView.register(TotalCell.self, forCellWithReuseIdentifier: TotalCell.reuseIdentifier)
        collectionView.register(
            ServicesHeader.self,
            forSupplementaryViewOfKind: servicesHeaderElementKind,
            withReuseIdentifier: ServicesHeader.reuseIdentifier
        )
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { fatalError() }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let layoutGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: self.layoutGroupSize(sectionIndex: sectionIndex),
                subitems: [layoutItem]
            )
            layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0)

            if Section(rawValue: sectionIndex) == .selected {
                layoutSection.boundarySupplementaryItems = [self.createServicesHeader()]
                let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: self.servicesHeaderElementKind
                )
                layoutSection.decorationItems = [sectionBackgroundDecoration]
            }

            return layoutSection
        }

        layout.register(ServicesHeader.self, forDecorationViewOfKind: servicesHeaderElementKind)

        return layout
    }

    private func layoutGroupSize(sectionIndex: Int) -> NSCollectionLayoutSize {
        guard let section = Section(rawValue: sectionIndex) else {
            fatalError("Unknown section type.")
        }

        switch section {
        case .selected:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(CGFloat(services.count) * 40)
            )
        case .addService:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        case .total:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(85))
        }
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            let factory = BillCellFactory(collectionView: collectionView)
            let cell = factory.getCell(with: itemIdentifier, for: indexPath)

            return cell
        }
    }

    private func configureSupplementaryViews() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == self.servicesHeaderElementKind,
               let servicesHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ServicesHeader.reuseIdentifier,
                for: indexPath
               ) as? ServicesHeader {
                servicesHeader.configure()

                return servicesHeader
            } else {
                return nil
            }
        }
    }

    private func createServicesHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(30)
        )
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: servicesHeaderElementKind,
            alignment: .top
        )
        layoutSectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)

        return layoutSectionHeader
    }

    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.selected, .addService, .total])
        snapshot.appendItems(services, toSection: .selected)
        snapshot.appendItems(addServiceAction, toSection: .addService)
        snapshot.appendItems(servicesTotal, toSection: .total)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension ServicesCountView: UICollectionViewDelegate {
}
