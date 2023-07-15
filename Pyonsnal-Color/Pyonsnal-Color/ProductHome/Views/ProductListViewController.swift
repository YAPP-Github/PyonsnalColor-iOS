//
//  ProductListViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

final class ProductListViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, BrandProductEntity>
    
    enum Constant {
        enum Size {
            static let spacing: CGFloat = 16
            static let productCellHeight: CGFloat = 235
            static let headerViewHeight: CGFloat = 22
            static let spacingCount: CGFloat = 3
            static let columnCount: CGFloat = 2
        }
    }
    
    enum Section {
        case product
    }
    
    //MARK: - Private Property
    private(set) var dataSource: DataSource?
    weak var delegate: ProductListDelegate?
    private let refreshControl: UIRefreshControl = .init()
    let convenienceStore: ConvenienceStore
    
    //MARK: - View Component
    lazy var productCollectionView: UICollectionView = {
        let layout = configureCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray100
        return collectionView
    }()
    
    init(convenienceStore: ConvenienceStore) {
        self.convenienceStore = convenienceStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureCollectionView()
        delegate?.didLoadPageList(store: convenienceStore)
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
        let totalSpacing = Constant.Size.spacingCount * Constant.Size.spacing
        let width = (UIScreen.main.bounds.width - totalSpacing) / Constant.Size.columnCount
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
            count: Int(Constant.Size.columnCount)
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
        configureRefreshControl()
    }
    
    private func registerCells() {
        productCollectionView.register(ProductCell.self)
        productCollectionView.registerHeaderView(ProductListHeaderView.self)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: productCollectionView
        ) { collectionView, indexPath, product in
            guard let cell: ProductCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ProductCell.self),
                for: indexPath
            ) as? ProductCell else {
                return UICollectionViewCell()
            }
            
            cell.updateCell(with: product)
            
            return cell
        }
    }
    
    private func configureHeaderView() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: ProductListHeaderView.self),
                    for: indexPath
                ) as? ProductListHeaderView else {
                    return nil
                }

                return headerView
            } else {
                return nil
            }
        }
    }
        
    private func configureRefreshControl() {
        refreshControl.addTarget(
            self,
            action: #selector(refreshByPull)
            , for: .valueChanged
        )
        productCollectionView.refreshControl = refreshControl
    }
    
    func applySnapshot(with products: [BrandProductEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BrandProductEntity>()
        
        snapshot.appendSections([.product])
        snapshot.appendItems(products)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: - Objective Method
    @objc
    private func refreshByPull() {
        productCollectionView.refreshControl?.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.refreshByPull()
            self.productCollectionView.refreshControl?.endRefreshing()
        }
    }
}
