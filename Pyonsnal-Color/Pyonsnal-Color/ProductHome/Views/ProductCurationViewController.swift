//
//  ProductCurationViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/22.
//

import UIKit
import SnapKit

final class ProductCurationViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    enum Size {
        static let cellCount: Int = 8
        static let cellHeight: CGFloat = 224
        static let imageHeight: CGFloat = 240
        static let headerHeight: CGFloat = 78
        static let footerHeight: CGFloat = 12
        static let spacing: CGFloat = Spacing.spacing12.value
        static let inset: NSDirectionalEdgeInsets = .init(
            top: Spacing.spacing16.value,
            leading: Spacing.spacing16.value,
            bottom: Spacing.spacing24.value,
            trailing: Spacing.spacing16.value
        )
    }
    
    enum Section: Hashable {
        case image
        case curation(data: CurationEntity)
    }
    
    enum Item: Hashable {
        case image(data: UIImage)
        case curation(data: BrandProductEntity)
    }
    
    private var dataSource: DataSource?
    var dummyData: [CurationEntity] = [
        CurationEntity(
            title: "HOT🔥 상품",
            description: "지금 사랑받고 있는 편의점별 단독 상품",
            products: []
        ),
        CurationEntity(
            title: "SNS✨ 추천 상품",
            description: "인플루언서들 사이에서 난리난 편의점별 단독 상품",
            products: []
        ),
        CurationEntity(
            title: "시험기간✍️ 추천 상품 ",
            description: "에너지, 카페인 충천을 위한 편의점별 단독 상품",
            products: []
        )
    ] {
        didSet {
            applySnapshot()
        }
    }
    
    lazy var curationCollectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        registerCells()
        configureDataSource()
        configureHeaderView()
        configureFooterView()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
            guard let section = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            switch section {
            case .image:
                return self.configureImageSection()
            case .curation:
                return self.configureCurationSection()
            }
        }
        
        return layout
    }
    
    private func configureLayout() {
        view.addSubview(curationCollectionView)
        
        curationCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Size.imageHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func configureCurationSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1.4)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.42),
            heightDimension: .absolute(Size.cellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = Size.spacing
        section.contentInsets = Size.inset
        section.boundarySupplementaryItems = configureSupplementaryView()
        
        return section
    }
    
    private func configureSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Size.headerHeight)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(Size.footerHeight)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        return [sectionHeader, sectionFooter]
    }
    
    private func registerCells() {
        curationCollectionView.register(ProductCell.self)
        curationCollectionView.registerHeaderView(CurationHeaderView.self)
        curationCollectionView.register(
            CurationFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: String(describing: CurationFooterView.self)
        )
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: curationCollectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .image:
                return UICollectionViewCell()
            case let .curation(data):
                let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateCell(with: data)
                return cell
            }
        }
    }
    
    private func configureHeaderView() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: CurationHeaderView.self),
                    for: indexPath
                ) as? CurationHeaderView else {
                    return nil
                }
                
                if let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] {
                    if case let .curation(curation) = section {
                        headerView.configureHeaderView(with: curation)
                    }
                }

                return headerView
            } else if kind == UICollectionView.elementKindSectionFooter {
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: CurationFooterView.self),
                    for: indexPath
                ) as? CurationFooterView else {
                    return nil
                }

                return footerView
            } else {
                return nil
            }
        }
    }
    
    private func configureFooterView() {
    }
    
    // TODO: 외부에서 CurationEntity 받아오는 로직으로 수정
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        dummyData.forEach { curation in
            snapshot.appendSections([.curation(data: curation)])
            curation.products.forEach { product in
                snapshot.appendItems([.curation(data: product)])
            }
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
