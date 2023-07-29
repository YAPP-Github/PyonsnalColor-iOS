//
//  ProductListViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

final class ProductListViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    
    enum Constant {
        enum Size {
            static let spacing: CGFloat = 16
            static let productCellHeight: CGFloat = 235
            static let headerViewHeight: CGFloat = 22
            static let spacingCount: CGFloat = 3
            static let columnCount: CGFloat = 2
        }
    }
    
    enum ProductSectionType {
        case empty, item
    }
    
    enum SectionType: Hashable {
        case keywordFilter
        case product(type: ProductSectionType)
    }
    
    enum ItemType: Hashable {
        case keywordFilter(data: KeywordFilter)
        case product(data: BrandProductEntity?)
    }
    
    //MARK: - Private Property
    private(set) var dataSource: DataSource?
    weak var delegate: ProductListDelegate?
    private let refreshControl: UIRefreshControl = .init()
    let convenienceStore: ConvenienceStore
    
    // MARK: - View Component
    lazy var productCollectionView: UICollectionView = {
        let layout = createLayout()
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureCollectionView()
        delegate?.didLoadPageList(store: convenienceStore)
    }
    
    // MARK: - Private Method
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
    
    // MARK: - Private Method
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

    private func configureCollectionView() {
        productCollectionView.backgroundColor = .gray100
        
        registerCells()
        configureDataSource()
        configureHeaderView()
        configureRefreshControl()
    }
    
    private func registerCells() {
        productCollectionView.register(KeywordFilterCell.self)
        productCollectionView.register(ProductCell.self)
        productCollectionView.register(EmptyProductCell.self)
        productCollectionView.register(ItemHeaderTitleView.self,
                                forSupplementaryViewOfKind: ItemHeaderTitleView.className,
                                withReuseIdentifier: ItemHeaderTitleView.className)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: productCollectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .keywordFilter(let keywordFilter):
                let cell: KeywordFilterCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(with: keywordFilter.name)
                return cell
            case .product(let brandProduct):
                if brandProduct == nil {
                    let cell: EmptyProductCell = collectionView.dequeueReusableCell(for: indexPath)
                    return cell
                } else {
                    let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.updateCell(with: brandProduct)
                    return cell
                }
            }
        }
    }
    
    private func configureHeaderView() {
        dataSource?.supplementaryViewProvider = makeSupplementaryView
    }
    
    private func makeSupplementaryView(
        collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView? {
        switch kind {
        case ItemHeaderTitleView.className:
            let itemHeaderTitleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: kind,
                for: indexPath
            ) as? ItemHeaderTitleView
            guard let section = dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                return nil
            }
            if section == .product(type: .item) {
                let itemTitle = "\(convenienceStore.convenienceStoreCellName) \(CommonConstants.productSectionHeaderTitle)"
                itemHeaderTitleView?.update(title: itemTitle)
            } else {
                return nil
            }
            return itemHeaderTitleView
        default:
            return nil
        }
    }
        
    private func configureRefreshControl() {
        refreshControl.addTarget(
            self,
            action: #selector(refreshByPull),
            for: .valueChanged
        )
        productCollectionView.refreshControl = refreshControl
    }
    
    func applySnapshot(with products: [BrandProductEntity]?) {
        productCollectionView.isScrollEnabled = true
        let itemSectionType = SectionType.product(type: .item)
        let emtpySectionType = SectionType.product(type: .empty)
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        // append keywordFilter
        let keywordItems = [KeywordFilter(name: "공부하기 좋은"), KeywordFilter(name: "야식용")].map { keywordFilter in
            ItemType.keywordFilter(data: keywordFilter)
        }
        if !keywordItems.isEmpty {
            snapshot.appendSections([.keywordFilter])
            snapshot.appendItems(keywordItems, toSection: .keywordFilter)
        }

        guard let products else { // 필터링 된 상품이 없을 경우 EmptyProductCell만 보여준다.
            productCollectionView.isScrollEnabled = false
            snapshot.appendSections([emtpySectionType])
            snapshot.appendItems([ItemType.product(data: nil)], toSection: emtpySectionType)
            dataSource?.apply(snapshot, animatingDifferences: true)
            return
        }
        
        // append product
        let productItems = products.map { product in
            return ItemType.product(data: product)
        }
        if !productItems.isEmpty {
            snapshot.appendSections([itemSectionType])
            snapshot.appendItems(productItems, toSection: itemSectionType)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollCollectionViewToTop() {
        productCollectionView.setContentOffset(
            .init(x: 0, y: Spacing.spacing16.negative.value),
            animated: true
        )
    }
    
    // MARK: - Objective Method
    @objc
    private func refreshByPull() {
        productCollectionView.refreshControl?.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.refreshByPull()
            self.productCollectionView.refreshControl?.endRefreshing()
        }
    }
}
