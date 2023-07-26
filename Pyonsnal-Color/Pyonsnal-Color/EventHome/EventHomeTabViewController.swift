//
//  PersonalViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/15.
//

import UIKit
import SnapKit

protocol ScrollDelegate: AnyObject {
    func didScroll(scrollView: UIScrollView)
    func willBeginDragging(scrollView: UIScrollView)
    func didEndDragging(scrollView: UIScrollView)
}

protocol EventHomeTabViewControllerDelegate: AnyObject {
    func didTapEventBannerCell(with imageUrl: String, store: ConvenienceStore)
    func didTapProductCell()
}

final class EventHomeTabViewController: UIViewController {
    
    enum SectionType: Hashable {
        case keywordFilter
        case event
        case item
    }
    
    enum ItemType: Hashable {
        case keywordFilter(KeywordFilter)
        case event(data: [EventBannerEntity])
        case item(data: EventProductEntity)
    }
    
    enum Size {
        static let topMargin: CGFloat = 20
    }
    
    weak var scrollDelegate: ScrollDelegate?
    weak var delegate: EventHomeTabViewControllerDelegate?
    weak var listDelegate: ProductListDelegate?
    
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createLayout())
        return collectionView
    }()
    
    // MARK: - Private property
    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    private var dataSource: DataSource?
    private let headerTitle: [EventHeaderSection] = CommonConstants.eventTabHeaderTitle
    private var eventUrls: [EventBannerEntity] = []
    private let refreshControl = UIRefreshControl()
    private var lastContentOffSetY: CGFloat = 0
    
    let convenienceStore: ConvenienceStore
    
    // MARK: - Initializer
    init(convenienceStore: ConvenienceStore) {
        self.convenienceStore = convenienceStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureCollectionView()
        configureDatasource()
        configureHeaderView()
        listDelegate?.didLoadPageList(store: convenienceStore)
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
    
    private func configureUI() {
        collectionView.backgroundColor = .gray100
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .gray100
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: Size.topMargin,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        registerCollectionViewCells()
        setRefreshControl()
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(ItemHeaderTitleView.self,
                                forSupplementaryViewOfKind: ItemHeaderTitleView.className,
                                withReuseIdentifier: ItemHeaderTitleView.className)
        collectionView.register(KeywordFilterCell.self)
        collectionView.register(EventBannerCell.self)
        collectionView.register(ProductCell.self)
    }
    
    private func setRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(pullToRefresh),
                                 for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func pullToRefresh() {
        collectionView.refreshControl?.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.listDelegate?.refreshByPull()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureDatasource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .keywordFilter(let keywordFilter):
                let cell: KeywordFilterCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(with: keywordFilter.name)
                return cell
            case .item(let item):
                let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateCell(with: item)
                return cell
            case .event(let item):
                let cell: EventBannerCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.update(item)
                cell.delegate = self
                return cell
            }
        }
    }
    
    private func configureHeaderView() {
        dataSource?.supplementaryViewProvider = makeSupplementaryView
    }
    
    private func makeSupplementaryView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        switch kind {
        case ItemHeaderTitleView.className:
            let itemHeaderTitleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: kind,
                for: indexPath
            ) as? ItemHeaderTitleView
            if dataSource?.snapshot().sectionIdentifiers[indexPath.section] == .keywordFilter { return nil }
            let sectionCount = dataSource?.snapshot().sectionIdentifiers.count
            let titleText = headerTitle[indexPath.section].text
            
            if sectionCount == 2 {
                if indexPath.section == 0 {
                    itemHeaderTitleView?.update(isEventLayout: true, title: titleText)
                } else {
                    itemHeaderTitleView?.update(isEventLayout: false, title: titleText)
                }
            } else {
                itemHeaderTitleView?.update(isEventLayout: false,
                                            title: headerTitle[1].text)
            }
            return itemHeaderTitleView
        default:
            return nil
        }
    }
    
    func applyEventProductsSnapshot(with products: [EventProductEntity]) {
        guard var snapshot = dataSource?.snapshot() else { return }
        
        let eventProducts = products.map { ItemType.item(data: $0) }
        
        if !snapshot.sectionIdentifiers.contains(.item) {
            snapshot.appendSections([.item])
        }
        
        snapshot.appendItems(eventProducts, toSection: .item)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func applyEventBannerProducts(with eventBanners: [EventBannerEntity]?, products: [EventProductEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        let eventBanners = eventBanners ?? []
        if !eventBanners.isEmpty {
            snapshot.appendSections([.event])
            snapshot.appendItems([ItemType.event(data: eventBanners)], toSection: .event)
        }
        
        let eventProducts = products.map { ItemType.item(data: $0) }
        
        if !snapshot.sectionIdentifiers.contains(.item) {
            snapshot.appendSections([.item])
        }
        
        snapshot.appendItems(eventProducts, toSection: .item)
        dataSource?.apply(snapshot, animatingDifferences: true)
        // 임시로 여기서 apply
        applyKeywordFilterSnapshot()
    }
    
    func applyKeywordFilterSnapshot() {
        guard var snapshot = dataSource?.snapshot() else { return }
        // append keywordFilter
        let keywordItems = [KeywordFilter(name: "공부하기 좋은"), KeywordFilter(name: "야식용")].map { keywordFilter in
            ItemType.keywordFilter(keywordFilter)
        }
        if !keywordItems.isEmpty {
            snapshot.insertSections([.keywordFilter], beforeSection: .event)
            snapshot.appendItems(keywordItems, toSection: .keywordFilter)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollCollectionViewToTop() {
        collectionView.setContentOffset(
            .init(x: 0, y: Spacing.spacing16.negative.value),
            animated: true
        )
    }
}

// MARK: - UICollectionViewDelegate
extension EventHomeTabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource?.itemIdentifier(for: indexPath),
           case let .item(product) = item {
            listDelegate?.didSelect(with: product)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(scrollView: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.willBeginDragging(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.didEndDragging(scrollView: scrollView)
    }
}

// MARK: - EventBannerCellDelegate
extension EventHomeTabViewController: EventBannerCellDelegate {
    func didTapEventBannerCell(with imageUrl: String, store: ConvenienceStore) {
        delegate?.didTapEventBannerCell(with: imageUrl, store: store)
    }
}
