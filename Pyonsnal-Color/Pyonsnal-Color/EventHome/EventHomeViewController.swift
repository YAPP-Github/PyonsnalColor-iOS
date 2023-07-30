//
//  EventHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import UIKit
import ModernRIBs
import SnapKit

protocol EventHomePresentableListener: AnyObject {
    func didLoadEventHome(with store: ConvenienceStore)
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore)
    func didTapSearchButton()
    func didChangeStore(to store: ConvenienceStore)
    func didScrollToNextPage(store: ConvenienceStore)
    func didSelect(with brandProduct: ProductConvertable)
    func didSelectFilter(of filter: FilterEntity?)
    func updateFilterSelectedState(with filter: FilterItemEntity) -> FilterDataEntity?
    func didTapRefreshFilterCell(with store: ConvenienceStore)
}

final class EventHomeViewController: UIViewController,
                                     EventHomePresentable,
                                     EventHomeViewControllable {
    // MARK: - Interface
    enum Size {
        static let titleLabelLeading: CGFloat = 16
        static let headerMargin: CGFloat = 11
        static let notificationButtonTrailing: CGFloat = 17
        static let headerViewHeight: CGFloat = 48
        static let collectionViewTop: CGFloat = 20
        static let collectionViewLeaing: CGFloat = 16
        static let storeCollectionViewSeparatorHeight: CGFloat = 1
    }
    
    enum Header {
        static let title = "행사 상품 모아보기"
    }
    
    enum TabBarItem {
        static let title = "행사 상품"
    }
    
    // MARK: - Interfaces
    weak var listener: EventHomePresentableListener?
    typealias SectionType = TopCollectionViewDatasource.SectionType
    typealias ItemType = TopCollectionViewDatasource.ItemType
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    private var dataSource: TopCollectionViewDatasource.DataSource?
    private var innerScrollLastOffsetY: CGFloat = 0
    private let convenienceStores: [String] = CommonConstants.convenienceStore
    private var initIndex: Int = 0
    private var isPaging: Bool = false
    private var currentConvenienceStore: ConvenienceStore?
    private var isNeedToShowRefreshCell: Bool {
        return listener?.needToShowRefreshCell() ?? false
    }
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureNavigationView()
        configureDatasource()
        initialSnapshot()
        configureCollectionView()
        setPageViewController()
        setScrollView()
        configureUI()
        loadFirstEventProducts()
    }
    
    // MARK: - Private method
    private func configureNavigationView() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func loadFirstEventProducts() {
        if let firstConvenienceStore = ConvenienceStore.allCases
            .first(where: { $0.convenienceStoreCellName == convenienceStores.first }) {
            self.currentConvenienceStore = firstConvenienceStore
            listener?.didLoadEventHome(with: firstConvenienceStore)
        }
    }
    
    private func configureDatasource() {
        dataSource = TopCollectionViewDatasource.DataSource(collectionView: viewHolder.collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .convenienceStore(let storeName):
                let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(title: storeName)
                if indexPath.row == self.initIndex { // 초기 상태 selected
                    self.setSelectedConvenienceStoreCell(with: indexPath)
                }
                return cell
            case .filter(let filterItem):
                switch filterItem.filterUseType {
                case .refresh:
                    let cell: RefreshFilterCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.delegate = self
                    return cell
                case .category:
                    guard let title = filterItem.filter?.defaultText else { return nil }
                    
                    let cell: CategoryFilterCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.configure(filter: filterItem.filter)
                    return cell
                }
            }
        }
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TopCollectionViewDatasource.SectionType, TopCollectionViewDatasource.ItemType>()
        // append store
        snapshot.appendSections([.convenienceStore(store: convenienceStores)])
        let items = convenienceStores.map { storeName in
            return ItemType.convenienceStore(storeName: storeName)
        }
        snapshot.appendItems(items, toSection: .convenienceStore(store: convenienceStores))
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyFilterSnapshot(with filters: FilterDataEntity?) {
        guard let filters else { return }
        guard var snapshot = dataSource?.snapshot() else { return }
        // TO DO : filter section delete 하지 않고 적용하는 방법
        snapshot.deleteSections([.filter])
        
        // append filter
        if !filters.data.isEmpty {
            snapshot.appendSections([.filter])
            if isNeedToShowRefreshCell {
                let refreshItem = FilterCellItem(filterUseType: .refresh, filter: nil)
                let refreshItems = [ItemType.filter(filterItem: refreshItem)]
                snapshot.appendItems(refreshItems, toSection: .filter)
            }
            let filters = setSortFilterState(with: filters)
            let filterItems = filters.data.map { filter in
                let filterItem = FilterCellItem(filter: filter)
                return ItemType.filter(filterItem: filterItem)
            }
            snapshot.appendItems(filterItems, toSection: .filter)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func setSortFilterState(with filters: FilterDataEntity) -> FilterDataEntity {
        let sortFilter = filters.data
            .first(where: { $0.filterType == .sort })
        let selectedsortFilter = sortFilter?.filterItem.first { $0.isSelected }
        let defaultSortFilterText = sortFilter?.filterType.filterDefaultText ?? ""
        let selectedFilterName: String = selectedsortFilter?.name ?? defaultSortFilterText
        sortFilter?.defaultText = selectedFilterName
        sortFilter?.isSelected = true
        return filters
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let layout = TopCommonSectionLayout()
            return layout.section(at: sectionIdentifier)
        }
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.register(ConvenienceStoreCell.self)
        viewHolder.collectionView.register(RefreshFilterCell.self)
        viewHolder.collectionView.register(CategoryFilterCell.self)
        viewHolder.collectionView.collectionViewLayout = createLayout()
    }
    
    private func setPageViewController() {
        addChild(viewHolder.pageViewController)
        viewHolder.pageViewController.didMove(toParent: self)
        viewHolder.pageViewController.pageDelegate = self
        viewHolder.pageViewController.scrollDelegate = self
    }
    
    private func setScrollView() {
        viewHolder.containerScrollView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func setupTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: TabBarItem.title,
            image: ImageAssetKind.TabBar.eventUnselected.image,
            selectedImage: ImageAssetKind.TabBar.eventSelected.image
        )
    }
    
    private func setSelectedConvenienceStoreCell(with indexPath: IndexPath) {
        viewHolder.collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .init()
        )
    }
    
    func updateProducts(with products: [EventProductEntity], at store: ConvenienceStore) {
        if let storeIndex = convenienceStores.firstIndex(of: store.convenienceStoreCellName) {
            let tabViewController = viewHolder.pageViewController.pageViewControllers[storeIndex]
            tabViewController.applyEventProductsSnapshot(with: products)
        }
    }
    
    func update(
        with products: [EventProductEntity],
        banners: [EventBannerEntity],
        at store: ConvenienceStore
    ) {
        if let storeIndex = convenienceStores.firstIndex(of: store.convenienceStoreCellName) {
            let tabViewController = viewHolder.pageViewController.pageViewControllers[storeIndex]
            tabViewController.applyEventBannerProducts(with: banners, products: products)
        }
    }
    
    func updateFilter(with filters: FilterDataEntity) {
        applyFilterSnapshot(with: filters)
    }
    
    func didFinishPaging() {
        isPaging = false
    }
    
    func updateFilterItems(with items: [FilterItemEntity]) {
        // TODO: 추가된 필터들 적용
        print(items)
    }
    
    func updateSortFilter(type: FilterItemEntity) {
        guard var snapshot = dataSource?.snapshot(for: .filter) else { return }
        let sortFilterIndex = 1, resetButtonIndex = 0
        let currentItem = snapshot.items[sortFilterIndex]
        let beforeItem = snapshot.items[resetButtonIndex]
        
        if case var .filter(item) = currentItem {
            item.filter?.defaultText = type.name
            snapshot.delete([currentItem])
            snapshot.insert([.filter(filterItem: item)], after: beforeItem)
            
            dataSource?.apply(snapshot, to: .filter)
        }
    }
    
}

// MARK: - UI Component
extension EventHomeViewController {
    
    class ViewHolder: ViewHolderable {
        
        let titleNavigationView: TitleNavigationView = {
            let titleNavigationView = TitleNavigationView()
            return titleNavigationView
        }()
        
        let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.bounces = false
            return scrollView
        }()
        
        let collectionView: UICollectionView = {
            let flowLayout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: flowLayout)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()
        
        let storeCollectionViewSeparator: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .gray200
            return view
        }()
        
        private let contentView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        private let contentPageView: UIView = {
            let view = UIView()
            return view
        }()
        
        lazy var pageViewController = EventHomePageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        func place(in view: UIView) {
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(contentView)
            contentView.addSubview(titleNavigationView)
            contentView.addSubview(storeCollectionViewSeparator)
            contentView.addSubview(collectionView)
            contentView.addSubview(contentPageView)
            contentPageView.addSubview(pageViewController.view)
        }
        
        func configureConstraints(for view: UIView) {
            containerScrollView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
            contentView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(containerScrollView.frameLayoutGuide.snp.height).priority(.low)
                $0.top.bottom.equalToSuperview()
            }
            
            titleNavigationView.snp.makeConstraints {
                $0.height.equalTo(Size.headerViewHeight)
                $0.top.leading.trailing.equalToSuperview()
            }
            
            collectionView.snp.makeConstraints {
                $0.top.equalTo(titleNavigationView.snp.bottom)
                $0.leading.equalToSuperview().offset(Size.collectionViewLeaing)
                $0.trailing.equalToSuperview().inset(Size.collectionViewLeaing)
                let height = TopCommonSectionLayout.ConvenienceStore.height + TopCommonSectionLayout.Filter.height
                $0.height.equalTo(height)
            }
            
            storeCollectionViewSeparator.snp.makeConstraints { make in
                make.height.equalTo(Size.storeCollectionViewSeparatorHeight)
                make.top.equalTo(collectionView.snp.bottom).inset(1)
                make.leading.trailing.equalToSuperview()
            }
            
            contentPageView.snp.makeConstraints {
                $0.top.equalTo(storeCollectionViewSeparator.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }

            pageViewController.view.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}

// MARK: - EventHomePageViewControllerDelegate
extension EventHomeViewController: EventHomePageViewControllerDelegate {

    func didSelect(with brandProduct: ProductConvertable) {
        listener?.didSelect(with: brandProduct)
    }
    
    func updateSelectedStoreCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        setSelectedConvenienceStoreCell(with: indexPath)
    }
    
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore) {
        listener?.didTapEventBannerCell(with: imageURL, store: store)
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        self.currentConvenienceStore = store
        listener?.didChangeStore(to: store)
    }
    
    func updateFilterState(with filter: FilterItemEntity) {
        // TO DO : filter 하나의 entity 상태 업데이트
        // applyFilterSnapshot(with: filterDataEntity)
    }
}

extension EventHomeViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
    }
}

// MARK: - UICollectionViewDelegate
extension EventHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == viewHolder.collectionView {
            guard let selectedItem = dataSource?.itemIdentifier(for: indexPath) else { return }
            
            switch selectedItem {
            case .convenienceStore:
                setSelectedConvenienceStoreCell(with: indexPath)
                viewHolder.pageViewController.updatePage(indexPath.row)
            case .filter(let filterItem):
                listener?.didSelectFilter(of: filterItem.filter)
            }

        }
    }
}

// MARK: - UIScrollViewDelegate
extension EventHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentViewController = viewHolder.pageViewController.viewControllers?.first,
              let tabViewController = currentViewController as? EventHomeTabViewController
        else {
            return
        }

        let collectionView = tabViewController.collectionView
        let outerScroll = scrollView == viewHolder.containerScrollView
        let innerScroll = !outerScroll
        let swipeDirectionY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let downScroll = swipeDirectionY < 0
        let upScroll = swipeDirectionY > 0
        let outerScrollMaxOffset: CGFloat = Size.headerViewHeight
        
        if innerScroll && upScroll {
            //안쪽을 위로 스크롤할때 바깥쪽 스크롤뷰의 contentOffset을 0으로 줄이기
            guard viewHolder.containerScrollView.contentOffset.y > 0 else { return }
            let scrolledHeight = innerScrollLastOffsetY - scrollView.contentOffset.y
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - scrolledHeight, 0)
            
            viewHolder.containerScrollView.contentOffset.y = maxOffsetY
            // 스크롤뷰의 contentOffset을 내림
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        let paginationHeight = abs(collectionView.contentSize.height - collectionView.bounds.height) * 0.9

        if innerScroll && !isPaging && paginationHeight <= collectionView.contentOffset.y {
            isPaging = true
            listener?.didScrollToNextPage(store: tabViewController.convenienceStore)
        }
        
        if innerScroll && downScroll {
            //안쪽을 아래로 스크롤할때 바깥쪽 먼저 아래로 스크롤
            guard viewHolder.containerScrollView.contentOffset.y < outerScrollMaxOffset else { return }
  
            let scrolledHeight = scrollView.contentOffset.y - innerScrollLastOffsetY
            let minOffsetY = min(
                viewHolder.containerScrollView.contentOffset.y + scrolledHeight,
                outerScrollMaxOffset
            )
            let offsetY = max(minOffsetY, 0)
            
            viewHolder.containerScrollView.contentOffset.y = offsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != viewHolder.containerScrollView {
            innerScrollLastOffsetY = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView != viewHolder.containerScrollView {
            innerScrollLastOffsetY = scrollView.contentOffset.y
        }
    }
}

// MARK: - ScrollDelegate
extension EventHomeViewController: ScrollDelegate {
    func didScroll(scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
    
    func willBeginDragging(scrollView: UIScrollView) {
        self.scrollViewWillBeginDragging(scrollView)
    }
    
    func didEndDragging(scrollView: UIScrollView) {
        self.scrollViewDidEndDragging(scrollView, willDecelerate: false)
    }
}

// MARK: - ProductPresentable
extension EventHomeViewController: ProductPresentable {
    func didTabRootTabBar() {
        guard let viewController = viewHolder.pageViewController.viewControllers?.first,
              let productListViewController = viewController as? EventHomeTabViewController
        else {
            return
        }
        
        productListViewController.scrollCollectionViewToTop()
    }
}

// MARK: - RefreshFilterCellDelegate
extension EventHomeViewController: RefreshFilterCellDelegate {
    func didTapRefreshButton() {
        if let currentConvenienceStore {
            listener?.didTapRefreshFilterCell(with: currentConvenienceStore)
        }
    }
}
