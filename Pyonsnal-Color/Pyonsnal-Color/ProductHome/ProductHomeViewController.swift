//
//  ProductHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol ProductHomePresentableListener: AnyObject {
    func didChangeStore(to store: ConvenienceStore, filterList: [String])
    func didTapSearchButton()
    func didTapNotificationButton()
    func didScrollToNextPage(store: ConvenienceStore, filterList: [String])
    func didSelect(with brandProduct: ProductConvertable?)
    func didSelectFilter(ofType filterEntity: FilterEntity?)
    func didTapRefreshFilterCell(with store: ConvenienceStore)
    func requestwithUpdatedKeywordFilter(with store: ConvenienceStore, filterList: [String])
}

final class ProductHomeViewController:
    UIViewController,
    ProductHomePresentable,
    ProductHomeViewControllable {
    
    // MARK: - Interface
    weak var listener: ProductHomePresentableListener?
    typealias StoreDataSource = TopCollectionViewDatasource.StoreDataSource
    typealias StoreSection = TopCollectionViewDatasource.SectionType
    typealias StoreItem = TopCollectionViewDatasource.ItemType
    
    typealias FilterDataSource = TopCollectionViewDatasource.FilterDataSource
    typealias FilterSection = TopCollectionViewDatasource.FilterSection
    typealias FilterItem = TopCollectionViewDatasource.FilterItem
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private var storeDataSource: StoreDataSource?
    private var filterDataSource: FilterDataSource?
    private let convenienceStores: [String] = CommonConstants.productHomeStore
    private let initialIndex: Int = 0
    private var innerScrollLastOffsetY: CGFloat = 0
    private var isPaging: Bool = false
    private var isRequestingInitialProducts: Bool = false
    private var currentPage: Int = 0
    private var currentConvenienceStore: ConvenienceStore?
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureCollectionView()
        configureFilterCollectionView()
        configureDataSource()
        initialStoreSnapshot()
        configureProductCollectionView()
        configureNotificationButton()
        configureNotificationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideFilterCollectionView()
    }
    
    // MARK: - Private Method
    private func configureDataSource() {
        configureStoreDatasource()
        configureFilterDataSource()
    }
    
    private func configureStoreDatasource() {
        storeDataSource = StoreDataSource(
            collectionView: viewHolder.collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case let .convenienceStore(storeName):
                let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(title: storeName)
                if indexPath.row == self.initialIndex { // 초기 상태 selected
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
    
    private func initialStoreSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<StoreSection, StoreItem>()
        snapshot.appendSections([.convenienceStore(store: convenienceStores)])
        let items = convenienceStores.map { storeName in
            return StoreItem.convenienceStore(storeName: storeName)
        }
        snapshot.appendItems(items, toSection: .convenienceStore(store: convenienceStores))
        
        storeDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyFilterSnapshot(with filters: FilterDataEntity?) {
        guard let filters else { return }
        var snapshot = NSDiffableDataSourceSnapshot<FilterSection, FilterItem>()
        
        if !filters.data.isEmpty {
            snapshot.appendSections([.filter])
            guard let filters = initializeFilterState(with: filters) else {
                return
            }
            
            let refreshItem = FilterCellItem(filterUseType: .refresh, filter: nil)
            let refreshItems = [FilterItem.filter(filterItem: refreshItem)]
            if needToShowRefreshCell() {
                snapshot.appendItems(refreshItems)
            } else {
                snapshot.deleteItems(refreshItems)
            }
            
            let filterItems = filters.data.map { filter in
                let filterItem = FilterCellItem(filter: filter)
                return FilterItem.filter(filterItem: filterItem)
            }
            snapshot.appendItems(filterItems)
        }
        
        filterDataSource?.apply(snapshot, animatingDifferences: true)
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
        guard let currentListViewController = currentListViewController() else { return nil }
        currentListViewController.initializeFilterState()
        Log.d(message: "초기 편의점 \(currentListViewController.convenienceStore) \(currentListViewController.getFilterDataEntity())")
        return currentListViewController.getFilterDataEntity()
    }
    
    private func updateSortFilterDefaultText(with filters: FilterDataEntity) -> FilterDataEntity? {
        guard let currentListViewController = currentListViewController() else { return nil }
        currentListViewController.updateSortFilterDefaultText()
        Log.d(message: "편의점 \(currentListViewController.convenienceStore) \(currentListViewController.getFilterDataEntity())")
        return currentListViewController.getFilterDataEntity()
    }
    
    private func setSelectedConvenienceStoreCell(with indexPath: IndexPath) {
        viewHolder.collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .init()
        )
    }
    
    private func setupViews() {
        let customFont: UIFont = .label2
        
        tabBarItem.setTitleTextAttributes([.font: customFont], for: .normal)
        tabBarItem = UITabBarItem(
            title: "차별화 상품",
            image: ImageAssetKind.TabBar.homeUnselected.image,
            selectedImage: ImageAssetKind.TabBar.homeSelected.image
        )
        
        view.backgroundColor = .white
        viewHolder.containerScrollView.delegate = self
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
    
    private func configureProductCollectionView() {
        viewHolder.productHomePageViewController.pagingDelegate = self
        viewHolder.productHomePageViewController.productListViewControllers
            .compactMap({ $0 as? ProductCurationViewController })
            .forEach {
                $0.delegate = self
                $0.curationDelegate = self
            }
        viewHolder.productHomePageViewController.productListViewControllers
            .compactMap({ $0 as? ProductListViewController })
            .forEach {
                $0.delegate = self
                $0.productCollectionView.delegate = self
            }
    }
    
    private func requestProducts(store: ConvenienceStore, filterList: [String]) {
        listener?.didChangeStore(to: store, filterList: filterList)
    }
    
    private func configureNotificationButton() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func hideFilterCollectionView() {
        viewHolder.filterCollectionView.isHidden = true
    }
    
    private func showFilterCollectionView() {
        viewHolder.filterCollectionView.isHidden = false
    }
    
    func showNotificationList(_ viewController: ModernRIBs.ViewControllable) {
        let notificationListViewController = viewController.uiviewController
        
        notificationListViewController.modalPresentationStyle = .fullScreen
        present(notificationListViewController, animated: true)
    }
    
    func updateProducts(with products: [ConvenienceStore: [BrandProductEntity]]) {
        guard let viewController = viewHolder.productHomePageViewController.viewControllers?.first,
              let productListViewController = viewController as? ProductListViewController
        else {
            return
        }
        
        if let products = products[productListViewController.convenienceStore] {
            productListViewController.applySnapshot(with: products)
        }
    }
    
    func updateProducts(with products: [BrandProductEntity], at store: ConvenienceStore) {
        if let storeIndex = ConvenienceStore.allCases.firstIndex(of: store) {
            self.currentConvenienceStore = store
            let pageViewController = viewHolder.productHomePageViewController
            if let viewController = pageViewController.productListViewControllers[storeIndex] as? ProductListViewController {
                viewController.applySnapshot(with: products)
                let keywordItems = viewController.getKeywordList()
                viewController.applyKeywordFilterSnapshot(with: keywordItems)
            }
        }
    }
    
    func replaceProducts(with products: [BrandProductEntity], at store: ConvenienceStore) {
        if let storeIndex = ConvenienceStore.allCases.firstIndex(of: store) {
            self.currentConvenienceStore = store
            let pageViewController = viewHolder.productHomePageViewController
            if let viewController = pageViewController.productListViewControllers[storeIndex] as? ProductListViewController {
                viewController.updateSnapshot(with: products)
                let keywordItems = viewController.getKeywordList()
                viewController.applyKeywordFilterSnapshot(with: keywordItems)
            }
        }
    }
    
    func updateFilter(with filters: FilterDataEntity) {
        viewHolder.productHomePageViewController.setFilterStateManager(with: filters)
        let initializedFilter = initializeFilterState(with: filters)
        applyFilterSnapshot(with: initializedFilter)
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
    
    func updateCuration(with products: [CurationEntity]) {
        let pageViewController = viewHolder.productHomePageViewController
        if let viewController = pageViewController.productListViewControllers.first as?
            ProductCurationViewController {
            viewController.applySnapshot(with: products)
        }
    }
    
    func currentListViewController() -> ProductListViewController? {
        let pageViewController = viewHolder.productHomePageViewController.viewControllers?.first
        if let productListViewController = pageViewController as? ProductListViewController {
            return productListViewController
        }
        return nil
    }
    
    func needToShowRefreshCell() -> Bool {
        guard let tabViewController = currentListViewController() else { return false }
        return tabViewController.needToShowRefreshCell()
	}

    func updateFilterItems(with items: [FilterItemEntity], type: FilterType) {
        // KeywordFilterCell 추가
        guard let listViewController = currentListViewController() else { return }
        
        let store = listViewController.convenienceStore
        
        // filterList update
        let filterList = items.map { String($0.code) }
        listViewController.appendFilterList(with: filterList, type: type)
        
        let updatedFilterList = listViewController.getFilterList()
        listener?.requestwithUpdatedKeywordFilter(with: store, filterList: updatedFilterList)
        
        // 해당 filterItems isSelected 값 변경, deselected된 아이템들은 !isSelected 값을 가져야 함
        listViewController.updateFiltersState(with: items, type: type)
        
        guard let filterDataEntity = listViewController.getFilterDataEntity() else { return }
        applyFilterSnapshot(with: filterDataEntity)
    }
    
    func updateSortFilter(item: FilterItemEntity) {
        guard let listViewController = currentListViewController() else { return }
        let store = listViewController.convenienceStore
        let sortFilterCode = [String(item.code)]
        listViewController.appendFilterList(with: sortFilterCode, type: .sort)
        
        let updatedFilterList = listViewController.getFilterList()
        listener?.requestwithUpdatedKeywordFilter(with: store, filterList: updatedFilterList)
        
        // 해당 filterItems isSelected 값 변경
        listViewController.updateSortFilterState(with: item)
        
        guard let filterDataEntity = listViewController.getFilterDataEntity() else { return }
        applyFilterSnapshot(with: filterDataEntity)
    }
}

// MARK: - TitleNavigationViewDelegate
extension ProductHomeViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
        listener?.didTapNotificationButton()
    }
}

// MARK: - UIScrollViewDelegate
extension ProductHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let productListViewController = currentListViewController() else { return }
        let collectionView = productListViewController.productCollectionView
        let outerScroll = scrollView == viewHolder.containerScrollView
        let innerScroll = !outerScroll
        let swipeDirectionY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let downScroll = swipeDirectionY < 0
        let upScroll = swipeDirectionY > 0
        let outerScrollMaxOffset = viewHolder.titleNavigationView.frame.height
        
        if innerScroll && upScroll {
            guard viewHolder.containerScrollView.contentOffset.y > 0 else { return }
            
            let scrolledHeight = innerScrollLastOffsetY - scrollView.contentOffset.y
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - scrolledHeight, 0)
            
            viewHolder.containerScrollView.contentOffset.y = maxOffsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        let paginationHeight = abs(collectionView.contentSize.height - collectionView.bounds.height) * 0.9

        if innerScroll && !isPaging && paginationHeight <= collectionView.contentOffset.y && !isRequestingInitialProducts {
            let filterList = productListViewController.getFilterList()
            listener?.didScrollToNextPage(
                store: ConvenienceStore.allCases[currentPage],
                filterList: filterList
            )
        }
        
        if innerScroll && downScroll {
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

// MARK: - UICollectionViewDelegate
extension ProductHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == viewHolder.collectionView {
            guard let selectedItem = storeDataSource?.itemIdentifier(for: indexPath) else { return }
            
            switch selectedItem {
            case .convenienceStore:
                currentPage = indexPath.item
                viewHolder.productHomePageViewController.updatePage(to: currentPage)
            }
        } else if collectionView == viewHolder.filterCollectionView {
            guard let selectedItem = filterDataSource?.itemIdentifier(for: indexPath) else { return }
            
            if case let .filter(filterEntity) = selectedItem {
                listener?.didSelectFilter(ofType: filterEntity.filter)
            }
        } else {
            guard let productListViewController =  viewHolder.productHomePageViewController.viewControllers?.first as? ProductListViewController,
                  let selectedItem = productListViewController.dataSource?.itemIdentifier(for: indexPath) else { return }
            
            switch selectedItem {
            case .product(let brandProduct):
                listener?.didSelect(with: brandProduct)
            default:
                break
            }
        }
    }
}

// MARK: - ProductHomePageViewControllerDelegate
extension ProductHomeViewController: ProductHomePageViewControllerDelegate {
    func didFinishPageTransition(index: Int) {
        currentPage = index
        let indexPath = IndexPath(item: index, section: 0)
        setSelectedConvenienceStoreCell(with: indexPath)
        applyFilterSnapshot(with: currentListViewController()?.getFilterDataEntity())
    }
}

// MARK: - ProductListDelegate
extension ProductHomeViewController: ProductListDelegate {
    
    func refreshFilterButton() {
        didTapRefreshButton()
    }
    
    // keyword delete시 호출
    func updateFilterState(with filter: FilterItemEntity, isSelected: Bool) {
        // filter isSelected 값 변경
        guard let listViewController = currentListViewController() else {
            return
        }
        listViewController.updateFilterState(with: filter, isSelected: isSelected)
        let filterCode = String(filter.code)
        listViewController.deleteFilterCode(at: filterCode)
        
        let filterDataEntity = listViewController.getFilterDataEntity()
        applyFilterSnapshot(with: filterDataEntity)
        
        let filterList = listViewController.getFilterList()
        listener?.requestwithUpdatedKeywordFilter(
            with: listViewController.convenienceStore,
            filterList: filterList
        )
        
        // keywordFilterList 가져와서 apply
        let keywordItems = listViewController.getKeywordList()
        listViewController.applyKeywordFilterSnapshot(with: keywordItems)
    }
    
    func didLoadPageList(store: ConvenienceStore) {
        requestProducts(store: store, filterList: [])
    }
    
    func refreshByPull(with filterList: [String]) {
        let store = ConvenienceStore.allCases[currentPage]
        requestProducts(store: store, filterList: filterList)
    }
    
    func didSelect(with brandProduct: ProductConvertable?) {
        guard let brandProduct else { return }
        listener?.didSelect(with: brandProduct)
    }
    
    func didAppearProductList() {
        showFilterCollectionView()
    }
    
    func didFinishUpdateSnapshot() {
        isRequestingInitialProducts = false
    }
}

// MARK: - ProductPresentable
extension ProductHomeViewController: ProductPresentable {
    func didTabRootTabBar() {
        let viewController = viewHolder.productHomePageViewController.viewControllers?.first
        if let listViewController = viewController as? ProductListViewController {
            listViewController.scrollCollectionViewToTop()
        } else if let curationViewController = viewController as? ProductCurationViewController {
            curationViewController.scrollCollectionViewToTop()
        }
    }
}

// MARK: - listViewController
extension ProductHomeViewController: RefreshFilterCellDelegate {
    func didTapRefreshButton() {
        guard let listViewController = currentListViewController() else {
            return
        }
        
        // request product
        listener?.didTapRefreshFilterCell(with: listViewController.convenienceStore)
        
        listViewController.resetFilterItemState()
        listViewController.deleteAllFilterCode()
        
        // apply filterData
        let filterDataEntity = listViewController.getFilterDataEntity()
        applyFilterSnapshot(with: filterDataEntity)
    }
}

// MARK: - CurationDelegate
extension ProductHomeViewController: CurationDelegate {
    func curationWillAppear() {
        hideFilterCollectionView()
    }
}
