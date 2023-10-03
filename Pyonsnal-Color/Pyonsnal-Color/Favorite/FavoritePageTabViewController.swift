//
//  FavoritePageTabViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/10/16.
//

import UIKit
import SnapKit

enum FavoriteButtonAction {
    case add
    case delete
}

protocol FavoritePageTabViewControllerDelegate: AnyObject {
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction)
    func didTapProduct(product: any ProductConvertable)
    func loadMoreItems()
    func pullToRefresh()
    func loadProducts()
}

final class FavoritePageTabViewController: UIViewController {
    
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
            lhs: FavoritePageTabViewController.ItemType,
            rhs: FavoritePageTabViewController.ItemType
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
    
    weak var delegate: FavoritePageTabViewControllerDelegate?
    
    // MARK: - Private Property
    private let viewHolder = ViewHolder()
    private(set) var dataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: self.view)
        viewHolder.configureConstraints(for: self.view)
        registerCell()
        configureCollectionView()
        configureDataSource()
        configureRefreshControl()
        delegate?.loadProducts()
    }
    
    // MARK: - Public Method
    func update(with data: [any ProductConvertable]?) {
        self.endRefreshing()
        self.makeSnapshot(with: data)
    }
    
    func scrollCollectionViewToTop() {
        viewHolder.collectionView.setContentOffset(.zero, animated: true)
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
    
    @objc
    func pullToRefresh() {
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
extension FavoritePageTabViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSizeHeight = self.viewHolder.collectionView.contentSize.height
        let contentOffsetY = self.viewHolder.collectionView.contentOffset.y
        let pagnationHeight = (contentSizeHeight - self.viewHolder.collectionView.bounds.height) * 0.9
        let remaining = pagnationHeight < contentOffsetY
        if remaining {
            delegate?.loadMoreItems()
        }
    }
}

// MARK: - ProductCellDelegate
extension FavoritePageTabViewController: ProductCellDelegate {
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction) {
        delegate?.didTapFavoriteButton(product: product, action: action)
    }
}