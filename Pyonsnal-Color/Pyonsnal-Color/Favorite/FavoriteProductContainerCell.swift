//
//  FavoriteProductContainerCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/13.
//

import UIKit

enum FavoriteButtonAction {
    case add
    case delete
}

protocol FavoriteProductContainerCellDelegate: AnyObject {
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction)
    func didTapProduct(product: any ProductConvertable)
    func loadMoreItems()
    func pullToRefresh()
}

final class FavoriteProductContainerCell: UICollectionViewCell {
    
    // MARK: - Interfaces
    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    
    enum SectionType {
        case product
        case empty
    }
    
    enum ItemType: Hashable {
        case product(product: any ProductConvertable)
        case empty
        
        static func == (
            lhs: FavoriteProductContainerCell.ItemType,
            rhs: FavoriteProductContainerCell.ItemType
        ) -> Bool {
            switch (lhs, rhs) {
            case (.product(let lProduct), .product(let rProduct)):
                return lProduct.productId == rProduct.productId
            case (.empty, .empty):
                return true
            default:
                return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .product(let product):
                hasher.combine(product.productId)
            case .empty:
                hasher.combine(1)
            }
        }
    }
    
    weak var delegate: FavoriteProductContainerCellDelegate?
    
    // MARK: - Private Property
    private let viewHolder = ViewHolder()
    private(set) var dataSource: DataSource?

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        registerCell()
        configureCollectionView()
        configureDataSource()
        configureRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    func update(with data: [any ProductConvertable]?) {
        makeSnapshot(with: data)
    }
    
    // MARK: - Private Method
    private func registerCell() {
        viewHolder.collectionView.register(ProductCell.self)
        viewHolder.collectionView.register(EmptyCell.self)
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.setCollectionViewLayout(
            self.createLayout(),
            animated: true
        )
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: viewHolder.collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .empty:
                let cell: EmptyCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setText(
                    titleText: EmptyCell.Text.Favorite.titleLabelText,
                    subTitleText: EmptyCell.Text.Favorite.subTitleLableText
                )
                return cell
            case .product(let product):
                let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateCell(with: product)
                cell.setFavoriteButton(isVisible: true)
                cell.setFavoriteButtonSelected(isSelected: true)
                cell.delegate = self
                return cell
            }
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let layout = CommonProductSectionLayout()
            return layout.section(at: sectionIdentifier)
        }
    }
    
    private func makeSnapshot(with data: [any ProductConvertable]?) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        
        if let data, !data.isEmpty {
            let products = data.map { product in
                return ItemType.product(product: product)
            }
            snapshot.appendSections([.product])
            snapshot.appendItems(products, toSection: .product)
        } else {
            snapshot.appendSections([.empty])
            snapshot.appendItems([.empty], toSection: .empty)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureRefreshControl() {
        viewHolder.collectionView.refreshControl?.addTarget(
            self,
            action: #selector(pullToRefresh),
            for: .valueChanged
        )
    }
    
    @objc func pullToRefresh() {
        viewHolder.collectionView.refreshControl?.beginRefreshing()
        delegate?.pullToRefresh()
    }
    
    func endRefreshing() {
        if viewHolder.collectionView.refreshControl?.isRefreshing ?? false {
            viewHolder.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    final class ViewHolder: ViewHolderable {
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(
                frame: .zero,
                collectionViewLayout: layout
            )
            collectionView.refreshControl = UIRefreshControl()
            return collectionView
        }()
        
        func place(in view: UIView) {
            view.addSubview(collectionView)
        }
        
        func configureConstraints(for view: UIView) {
            collectionView.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteProductContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = dataSource?.itemIdentifier(for: indexPath),
           case let .product(item) = product {
            if let item = item as? EventProductEntity {
                if item.isEventExpired ?? false { return }
            }
            delegate?.didTapProduct(product: item)
        }
    }
}

// MARK: - Pagnation
extension FavoriteProductContainerCell {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSizeHeight = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let pagnationHeight = (contentSizeHeight - scrollView.frame.size.height) * 0.9
        let remaining = pagnationHeight < contentOffsetY
        if remaining {
            delegate?.loadMoreItems()
        }
    }
}

// MARK: - ProductCellDelegate
extension FavoriteProductContainerCell: ProductCellDelegate {
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction) {
        delegate?.didTapFavoriteButton(product: product, action: action)
    }
    
}
