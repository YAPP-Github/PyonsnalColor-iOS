//
//  ProductListViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

final class ProductListViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    
    enum Constant {
        enum Size {
            static let spacing: CGFloat = 16
            static let productCellHeight: CGFloat = 235
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
        collectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: ProductCell.identifier
        )
        collectionView.backgroundColor = .systemGray6
        return collectionView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureDataSource()
    }
    
    //MARK: - Private Method
    private func configureLayout() {
        view.addSubview(productCollectionView)
        
        productCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constant.Size.spacing,
            bottom: 0,
            trailing: Constant.Size.spacing
        )
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: productCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            guard let cell: ProductCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCell.identifier,
                for: indexPath
            ) as? ProductCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    
    //MARK: - Internal Method
    func applySnapshot(sections: [Section], items: [Int]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        
        snapshot.appendSections(sections)
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
