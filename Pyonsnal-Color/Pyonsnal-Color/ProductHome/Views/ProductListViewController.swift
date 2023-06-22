//
//  ProductListViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

final class ProductListViewController: UIViewController {
    //TODO: Item타입 상품엔티티로 변경
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    
    enum Constant {
        enum Size {
            static let spacing: CGFloat = 16
            static let productCellHeight: CGFloat = 235
            static let headerViewHeight: CGFloat = 22
        }
    }
    
    enum Section {
        case product
    }
    
    //MARK: - Private Property
    private var dataSource: DataSource?
    
    //MARK: - View Component
    private lazy var productCollectionView: UICollectionView = {
        let layout = configureCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //TODO: AppColor 정해지면 수정
        collectionView.backgroundColor = .systemGray6
        return collectionView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureCollectionView()
    }
    
    //MARK: - Private Method
    private func configureLayout() {
        view.addSubview(productCollectionView)
        
        productCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productCollectionView.contentInset = UIEdgeInsets(
            top: Constant.Size.spacing,
            left: 0,
            bottom: 0,
            right: 0
        )
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let width = (UIScreen.main.bounds.width - Constant.Size.spacing * 3) / 2
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constant.Size.productCellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(Constant.Size.spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.Size.spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constant.Size.spacing,
            bottom: 0,
            trailing: Constant.Size.spacing
        )
        section.boundarySupplementaryItems = setupSupplementaryView()
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Constant.Size.headerViewHeight)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return [sectionHeader]
    }
    
    private func configureCollectionView() {
        registerCells()
        configureDataSource()
        configureHeaderView()
        applySnapshot()
    }
    
    private func registerCells() {
        productCollectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: ProductCell.identifier
        )
        productCollectionView.register(
            ProductListHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProductListHeaderView.identifier
        )
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: productCollectionView
        ) { collectionView, indexPath, _ in
            guard let cell: ProductCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCell.identifier,
                for: indexPath
            ) as? ProductCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    
    private func configureHeaderView() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProductListHeaderView.identifier,
                    for: indexPath
                ) as? ProductListHeaderView else {
                    return nil
                }

                headerView.configureLayout()
                return headerView
            } else {
                return nil
            }
        }
    }
    
    //MARK: - Internal Method
    private func applySnapshot() {
        //TODO: 추후에 외부로부터 데이터 받아오도록 메서드 추가
        //ex) updateSnapshot(items: [ProductEntity])
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        
        snapshot.appendSections([.product])
        snapshot.appendItems(Array(1...40))
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
