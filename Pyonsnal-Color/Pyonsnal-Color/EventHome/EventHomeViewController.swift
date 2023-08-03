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
    func didChangeStore(to store: ConvenienceStore, filterList: [String])
    func didScrollToNextPage(store: ConvenienceStore, filterList: [String])
    func didSelect(with brandProduct: ProductConvertable)
    func didSelectFilter(of filter: FilterEntity?)
    func didTapRefreshFilterCell(with store: ConvenienceStore)
    func requestwithUpdatedKeywordFilter(with store: ConvenienceStore, filterList: [String])
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
        static let storeHeight: CGFloat = 44
        static let storeCollectionViewSeparatorHeight: CGFloat = 1
        static let filterMargin: UIEdgeInsets = .init(top: 12, left: 15, bottom: 12, right: 15)
        static let filterHeight: CGFloat = 56
    }
    
    enum Header {
        static let title = "행사 상품 모아보기"
    }
    
    enum TabBarItem {
        static let title = "행사 상품"
    }
    
    // MARK: - Interfaces
    weak var listener: EventHomePresentableListener?
    typealias StoreDataSource = TopCollectionViewDatasource.StoreDataSource
    typealias StoreSection = TopCollectionViewDatasource.SectionType
    typealias StoreItem = TopCollectionViewDatasource.ItemType
    
    typealias FilterDataSource = TopCollectionViewDatasource.FilterDataSource
    typealias FilterSection = TopCollectionViewDatasource.FilterSection
    typealias FilterItem = TopCollectionViewDatasource.FilterItem
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    private var storeDataSource: StoreDataSource?
    private var filterDataSource: FilterDataSource?
    private var innerScrollLastOffsetY: CGFloat = 0
    private let convenienceStores: [String] = CommonConstants.convenienceStore
    private var initIndex: Int = 0
    private var isPaging: Bool = false
    private var isRequestingInitialProducts: Bool = false
    private var currentConvenienceStore: ConvenienceStore?
    
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
        configureCollectionView()
        configureFilterCollectionView()
        configureDataSource()
        initialSnapshot()
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
            listener?.didLoadEventHome(with: firstConvenienceStore)
        }
    }
    
    private func configureDataSource() {
        configureStoreDatasource()
        configureFilterDataSource()
    }
    
    private func configureStoreDatasource() {
        storeDataSource = StoreDataSource(collectionView: viewHolder.collectionView)
        { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case let .convenienceStore(storeName):
                let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(title: storeName)
                if indexPath.row == self.initIndex { // 초기 상태 selected
                    self.setSelectedConvenienceStoreCell(with: indexPath)
                }
                return cell
            }
        }
    }
    
    private func configureFilterDataSource() {
        filterDataSource = FilterDataSource(
            collectionView: viewHolder.filterCollectionView
        ) { collectionView, index, item -> UICollectionViewCell? in
            switch item {
            case let .filter(filterItem):
                switch filterItem.filterUseType {
                case .refresh:
                    let cell: RefreshFilterCell = collectionView.dequeueReusableCell(for: index)
                    cell.delegate = self
                    return cell
                case .category:
                    let cell: CategoryFilterCell = collectionView.dequeueReusableCell(for: index)
                    cell.configure(filter: filterItem.filter)
                    return cell
                }
            }
        }
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<StoreSection, StoreItem>()
        snapshot.appendSections([.convenienceStore(store: convenienceStores)])
        let items = convenienceStores.map { storeName in
            return StoreItem.convenienceStore(storeName: storeName)
        }
        snapshot.appendItems(items)
        
        storeDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyFilterSnapshot(with filters: FilterDataEntity?) {
        guard let filters else { return }
        var snapshot = NSDiffableDataSourceSnapshot<FilterSection, FilterItem>()
        
        if !filters.data.isEmpty {
            snapshot.appendSections([.filter])
            guard let filters = updatedSortFilterState(with: filters) else { return }
            
            if needToShowRefreshCell() {
                let refreshItem = FilterCellItem(filterUseType: .refresh, filter: nil)
                let refreshItems = [FilterItem.filter(filterItem: refreshItem)]
                snapshot.appendItems(refreshItems)
            }
            
            let filterItems = filters.data.map { filter in
                let filterItem = FilterCellItem(filter: filter)
                return FilterItem.filter(filterItem: filterItem)
            }
            snapshot.appendItems(filterItems)
        }
        
        filterDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    // TO DO : 로직 리팩토링
    private func updatedSortFilterState(with filters: FilterDataEntity) -> FilterDataEntity? {
        // 첫 정렬인지 체크
        if filters.data.first(where: { $0.filterType == .sort })?.defaultText == nil {
            return initializeFilterState(with: filters)
        }
        return updateSortFilterDefaultText(with: filters)
    }
    
    private func initializeFilterState(with filters: FilterDataEntity) -> FilterDataEntity? {
        guard let currentTabViewController = currentTabViewController() else { return nil }
        currentTabViewController.initializeFilterState()
        return currentTabViewController.getFilterDataEntity()
    }
    
    private func updateSortFilterDefaultText(with filters: FilterDataEntity) -> FilterDataEntity? {
        guard let currentTabViewController = currentTabViewController() else { return nil }
        currentTabViewController.updateSortFilterDefaultText()
        return currentTabViewController.getFilterDataEntity()
    }
    
    private func createStoreLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (index, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifiers = self?.storeDataSource?.snapshot().sectionIdentifiers[index] else {
                return nil
            }
            
            if case let .convenienceStore(stores) = sectionIdentifiers {
                let layout = TopCommonSectionLayout()
                return layout.convenienceStoreLayout(convenienceStore: stores)
            }
            return nil
        }
    }
    
    private func createFilterLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifiers = self?.storeDataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let layout = TopCommonSectionLayout()
            return layout.filterLayout()
        }
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.register(ConvenienceStoreCell.self)
        viewHolder.collectionView.collectionViewLayout = createStoreLayout()
    }
    
    private func configureFilterCollectionView() {
        viewHolder.filterCollectionView.delegate = self
        viewHolder.filterCollectionView.register(CategoryFilterCell.self)
        viewHolder.filterCollectionView.register(RefreshFilterCell.self)
        viewHolder.filterCollectionView.collectionViewLayout = createFilterLayout()
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
            let keywordItems = tabViewController.getKeywordList()
            tabViewController.applyKeywordFilterSnapshot(with: keywordItems)
        }
    }
    
    func updateFilter(with filters: FilterDataEntity) {
        viewHolder.pageViewController.setFilterStateManager(with: filters)
        applyFilterSnapshot(with: filters)
    }
    
    func didStartPaging() {
        isPaging = true
    }
    
    func didFinishPaging() {
        isPaging = false
    }
    
    func requestInitialProduct() {
        isRequestingInitialProducts = true
    }
    
    func currentTabViewController() -> EventHomeTabViewController? {
        guard let currentViewController = viewHolder.pageViewController.viewControllers?.first,
              let currentTabViewController = currentViewController as? EventHomeTabViewController else {
            return nil
        }
        return currentTabViewController
    }
    
    func needToShowRefreshCell() -> Bool {
        guard let tabViewController = currentTabViewController() else { return false }
        return tabViewController.needToShowRefreshCell()
    }
    
    func updateFilterItems(with items: [FilterItemEntity], filterType: FilterType) {
        // KeywordFilterCell 추가
        guard let tabViewController = currentTabViewController() else { return }
        let store = tabViewController.convenienceStore
        
        // filterList update
        let filterList = items.map { String($0.code) }
        tabViewController.appendFilterList(with: filterList, type: filterType)
        
        let updatedFilterList = tabViewController.getFilterList()
        listener?.requestwithUpdatedKeywordFilter(with: store, filterList: updatedFilterList)
        
        // 해당 filterItems isSelected 값 변경, deselected된 아이템들은 !isSelected 값을 가져야 함
        tabViewController.updateFiltersState(with: items, type: filterType)
        
        guard let filterDataEntity = tabViewController.getFilterDataEntity() else { return }
        applyFilterSnapshot(with: filterDataEntity)
    }
    
    func updateSortFilter(item: FilterItemEntity) {
        guard let tabViewController = currentTabViewController() else { return }
        let store = tabViewController.convenienceStore
        let sortFilterCode = [String(item.code)]
        tabViewController.appendFilterList(with: sortFilterCode, type: .sort)
        
        let updatedFilterList = tabViewController.getFilterList()
        listener?.requestwithUpdatedKeywordFilter(with: store, filterList: updatedFilterList)
        
        // 해당 filterItems isSelected 값 변경
        tabViewController.updateSortFilterState(with: item)
        
        guard let filterDataEntity = tabViewController.getFilterDataEntity() else { return }
        applyFilterSnapshot(with: filterDataEntity)
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
        
        let filterCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.layoutMargins = Size.filterMargin
            return collectionView
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
            contentView.addSubview(filterCollectionView)
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
                $0.height.equalTo(Size.storeHeight)
            }
            
            storeCollectionViewSeparator.snp.makeConstraints { make in
                make.height.equalTo(Size.storeCollectionViewSeparatorHeight)
                make.top.equalTo(collectionView.snp.bottom).inset(1)
                make.leading.trailing.equalToSuperview()
            }
            
            filterCollectionView.snp.makeConstraints {
                $0.height.equalTo(Size.filterHeight)
                $0.top.equalTo(storeCollectionViewSeparator.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
            
            contentPageView.snp.makeConstraints {
                $0.top.equalTo(filterCollectionView.snp.bottom)
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
    func refreshFilterButton() {
        didTapRefreshButton()
    }
    
    func didSelect(with brandProduct: ProductConvertable) {
        listener?.didSelect(with: brandProduct)
    }
    
    func updateSelectedStoreCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        setSelectedConvenienceStoreCell(with: indexPath)
        applyFilterSnapshot(with: currentTabViewController()?.getFilterDataEntity())
    }
    
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore) {
        listener?.didTapEventBannerCell(with: imageURL, store: store)
    }
    
    func didChangeStore(to store: ConvenienceStore, filterList: [String]) {
        listener?.didChangeStore(to: store, filterList: filterList)
    }
    
    func deleteFilterItem(with filter: FilterItemEntity, isSelected: Bool) {
        // filter isSelected 값 변경
        guard let tabViewController = currentTabViewController() else { return }
        
        tabViewController.updateFilterState(with: filter, isSelected: isSelected)
        let filterCode = String(filter.code)
        tabViewController.deleteFilterCode(at: filterCode)
        
        guard let filterDataEntity = tabViewController.getFilterDataEntity() else { return }
        applyFilterSnapshot(with: filterDataEntity)
        
        let filterList = tabViewController.getFilterList()
        listener?.requestwithUpdatedKeywordFilter(
            with: tabViewController.convenienceStore,
            filterList: filterList
        )
        
        // keywordFilterList 가져와서 apply
        let keywordItems = tabViewController.getKeywordList()
        tabViewController.applyKeywordFilterSnapshot(with: keywordItems)
    }
    
    func didFinishUpdateSnapshot() {
        isRequestingInitialProducts = false
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
            guard let selectedItem = storeDataSource?.itemIdentifier(for: indexPath) else { return }
            
            if case .convenienceStore(_) = selectedItem {
                setSelectedConvenienceStoreCell(with: indexPath)
                viewHolder.pageViewController.updatePage(indexPath.row)
            }
        } else if collectionView == viewHolder.filterCollectionView {
            guard let selectedItem = filterDataSource?.itemIdentifier(for: indexPath) else { return }
            
            if case let .filter(filterItem) = selectedItem {
                listener?.didSelectFilter(of: filterItem.filter)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension EventHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tabViewController = currentTabViewController() else { return }
        
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
        
        if innerScroll && !isPaging && paginationHeight <= collectionView.contentOffset.y && !isRequestingInitialProducts {
            let filterList = tabViewController.getFilterList()
            listener?.didScrollToNextPage(
                store: tabViewController.convenienceStore,
                filterList: filterList
            )
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
        guard let tabViewController = currentTabViewController() else {
            return
        }
        
        tabViewController.scrollCollectionViewToTop()
    }
    
}

// MARK: - RefreshFilterCellDelegate
extension EventHomeViewController: RefreshFilterCellDelegate {
    func didTapRefreshButton() {
        guard let tabViewController = currentTabViewController() else {
            return
        }
        
        // request product
        listener?.didTapRefreshFilterCell(with: tabViewController.convenienceStore)
        
        // filter isSelected state update
        tabViewController.resetFilterItemState()
        tabViewController.deleteAllFilterCode()
        
        // apply filterData
        let filterDataEntity = tabViewController.getFilterDataEntity()
        applyFilterSnapshot(with: filterDataEntity)
    }
}
