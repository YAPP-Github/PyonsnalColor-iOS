//
//  ProductHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol ProductHomePresentableListener: AnyObject {
    func didChangeStore(to store: ConvenienceStore)
    func didTapSearchButton()
    func didTapNotificationButton()
    func didScrollToNextPage(store: ConvenienceStore)
    func didSelect(with brandProduct: ProductConvertable?)
    func didSelectFilter(ofType filterEntity: FilterEntity?)
    func updateFilterSelectedState(with filter: FilterItemEntity) -> FilterDataEntity?
    func didTapRefreshFilterCell(with store: ConvenienceStore)
}

final class ProductHomeViewController:
    UIViewController,
    ProductHomePresentable,
    ProductHomeViewControllable {

    // MARK: - Interface
    weak var listener: ProductHomePresentableListener?
    typealias SectionType = TopCollectionViewDatasource.SectionType
    typealias ItemType = TopCollectionViewDatasource.ItemType
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private var dataSource: TopCollectionViewDatasource.DataSource?
    private let convenienceStores: [String] = CommonConstants.productHomeStore
    private let initialIndex: Int = 0
    private var innerScrollLastOffsetY: CGFloat = 0
    private var isPaging: Bool = false
    private var currentPage: Int = 0
    private var currentConvenienceStore: ConvenienceStore?
    private var isNeedToShowRefreshCell: Bool {
        return true
//        return listener?.needToShowRefreshCell() ?? false
    }
    
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
        configureDatasource()
        initialSnapshot()
        configureCollectionView()
        configureProductCollectionView()
        configureNotificationButton()
    }
    
    // MARK: - Private Method
    private func configureDatasource() {
        dataSource = TopCollectionViewDatasource.DataSource(collectionView: viewHolder.collectionView)
        { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .convenienceStore(let storeName):
                let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(title: storeName)
                if indexPath.row == self.initialIndex { // 초기 상태 selected
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
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
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
        viewHolder.collectionView.register(CategoryFilterCell.self)
        viewHolder.collectionView.register(RefreshFilterCell.self)
        viewHolder.collectionView.collectionViewLayout = createLayout()
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
    
    private func configureProductCollectionView() {
        viewHolder.productHomePageViewController.pagingDelegate = self
        viewHolder.productHomePageViewController.productListViewControllers
            .compactMap({ $0 as? ProductCurationViewController })
            .forEach { $0.delegate = self }
        viewHolder.productHomePageViewController.productListViewControllers
            .compactMap({ $0 as? ProductListViewController })
            .forEach {
                $0.delegate = self
                $0.productCollectionView.delegate = self
            }
    }
    
    private func setSelectedConvenienceStoreCell(with page: Int) {
        viewHolder.collectionView.selectItem(
            at: IndexPath(item: page, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
    
    private func requestProducts(store: ConvenienceStore) {
        listener?.didChangeStore(to: store)
    }
    
    private func configureNotificationButton() {
        viewHolder.titleNavigationView.delegate = self
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
            } else if let curationVC = pageViewController.productListViewControllers[storeIndex] as? ProductCurationViewController {
                // TODO: Curation 전달 로직 수정
                curationVC.dummyData[0].products = Array(products[0...6])
                curationVC.dummyData[1].products = Array(products[7...12])
                curationVC.dummyData[2].products = Array(products[13...18])
            }
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

// MARK: - TitleNavigationViewDelegate {
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
        let pageViewController = viewHolder.productHomePageViewController
        guard let currentViewController = pageViewController.viewControllers?.first,
              let productListViewController = currentViewController as? ProductListViewController
        else {
            return
        }
        
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

        if innerScroll && !isPaging && paginationHeight <= collectionView.contentOffset.y {
            isPaging = true
            listener?.didScrollToNextPage(store: ConvenienceStore.allCases[currentPage])
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
            guard let selectedItem = dataSource?.itemIdentifier(for: indexPath) else { return }
            
            switch selectedItem {
            case .convenienceStore:
                currentPage = indexPath.item
                viewHolder.productHomePageViewController.updatePage(to: currentPage)
            case .filter(let filterItem):
                listener?.didSelectFilter(ofType: filterItem.filter)
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
        setSelectedConvenienceStoreCell(with: currentPage)
    }
}

// MARK: - ProductListDelegate
extension ProductHomeViewController: ProductListDelegate {
    func refreshFilterButton() {
        let store = ConvenienceStore.allCases[currentPage]
        requestProducts(store: store)
    }
    
    func updateFilterState(with filter: FilterItemEntity) {
        let filterDataEntity = listener?.updateFilterSelectedState(with: filter)
        applyFilterSnapshot(with: filterDataEntity)
    }
    
    func didLoadPageList(store: ConvenienceStore) {
        requestProducts(store: store)
    }
    
    func refreshByPull() {
        let store = ConvenienceStore.allCases[currentPage]
        requestProducts(store: store)
    }
    
    func didSelect(with brandProduct: ProductConvertable?) {
        guard let brandProduct else { return }
        listener?.didSelect(with: brandProduct)
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

extension ProductHomeViewController: RefreshFilterCellDelegate {
    func didTapRefreshButton() {
        if let currentConvenienceStore {
            listener?.didTapRefreshFilterCell(with: currentConvenienceStore)
        }
    }
}
