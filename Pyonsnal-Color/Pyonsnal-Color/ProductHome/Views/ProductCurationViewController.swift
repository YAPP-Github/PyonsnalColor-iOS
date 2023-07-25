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
        static let cellHeight: CGFloat = 233
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
        case image(data: UIImage?)
        case curation(data: BrandProductEntity)
    }
    
    weak var delegate: ProductListDelegate?
    
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
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        curationCollectionView.delegate = self
        configureLayout()
        registerCells()
        configureDataSource()
        configureSupplementaryView()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
            guard let section = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            switch section {
            case .image:
                return self.createImageSection()
            case .curation:
                return self.createCurationSection()
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
    
    private func createImageSection() -> NSCollectionLayoutSection {
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
    
    private func createCurationSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.42),
            heightDimension: .estimated(Size.cellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = Size.spacing
        section.contentInsets = Size.inset
        section.boundarySupplementaryItems = createSupplementaryView()
        
        return section
    }
    
    private func createSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
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
                widthDimension: .absolute(UIScreen.main.bounds.width),
                heightDimension: .absolute(Size.footerHeight)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        return [sectionHeader, sectionFooter]
    }
    
    private func registerCells() {
        curationCollectionView.register(CurationImageCell.self)
        curationCollectionView.register(ProductCell.self)
        curationCollectionView.registerHeaderView(CurationHeaderView.self)
        curationCollectionView.registerFooterView(CurationFooterView.self)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: curationCollectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .image:
                let cell: CurationImageCell = collectionView.dequeueReusableCell(for: indexPath)
                return cell
            case let .curation(data):
                let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateCell(with: data)
                return cell
            }
        }
    }
    
    private func configureSupplementaryView() {
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
                
                if let numberOfSection = self.dataSource?.numberOfSections(in: collectionView) {
                    if indexPath.section == numberOfSection - 1 {
                        footerView.isHidden = true
                    }
                }

                return footerView
            } else {
                return nil
            }
        }
    }
    
    // TODO: 외부에서 CurationEntity 받아오는 로직으로 수정
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // TODO: 이미지 변경
        snapshot.appendSections([.image])
        snapshot.appendItems([.image(data: UIImage(systemName: ""))])
        
        dummyData.forEach { curation in
            snapshot.appendSections([.curation(data: curation)])
            curation.products.forEach { product in
                snapshot.appendItems([.curation(data: product)])
            }
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollCollectionViewToTop() {
        curationCollectionView.setContentOffset(.init(x: 0, y: 0), animated: true)
    }
}

extension ProductCurationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource?.itemIdentifier(for: indexPath)
        
        if case let .curation(product) = item {
            delegate?.didSelect(with: product)
        }
    }
}
