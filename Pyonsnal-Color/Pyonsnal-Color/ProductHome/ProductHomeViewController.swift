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
    func didSelect(with brandProduct: ProductConvertable)
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
    private let filterItem: [FilterItem] = []
    private let initialIndex: Int = 0
    private var innerScrollLastOffsetY: CGFloat = 0
    private var isPaging: Bool = false
    private var currentPage: Int = 0
    
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
        makeSnapshot()
        setupCollectionView()
        setupProductCollectionView()
        configureNotificationButton()
    }
    
    // MARK: - Private Method
    private func configureDatasource() {
        dataSource = TopCollectionViewDatasource.DataSource(collectionView: viewHolder.collectionView)
        { collectionView, indexPath, item -> UICollectionViewCell? in
            print("snapshot \(indexPath) \(item)")
            switch item {
            case .convenienceStore(let storeName):
                let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(title: storeName)
                if indexPath.row == self.initialIndex { // 초기 상태 selected
                    self.setSelectedConvenienceStoreCell(with: indexPath)
                }
                return cell
            case .filter(let filter):
                let cell: CategoryFilterCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(with: filter.defaultText, filterItem: [])
                return cell
            }
            
        }
    }
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        // append store
        snapshot.appendSections([.convenienceStore(store: convenienceStores)])
        let items = convenienceStores.map { storeName in
            return ItemType.convenienceStore(storeName: storeName)
        }
        snapshot.appendItems(items, toSection: .convenienceStore(store: convenienceStores))
        
        // append filter
        let filters = makeCategoryFilter()
        if !filters.isEmpty {
            snapshot.appendSections([.filter])
            let filterItems = filters.map { filter in
                return ItemType.filter(filterItem: filter)
            }
            snapshot.appendItems(filterItems, toSection: .filter)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func makeCategoryFilter() -> [CategoryFilter] {
        var categoryFilters: [CategoryFilter] = []
        // 정렬
        if !FilterDummy.data.sortedMeta.isEmpty {
            if let sortDefaultText = FilterDummy.data.sortedMeta.first(where: { $0.isSelected })?.name {
                categoryFilters.append(CategoryFilter(defaultText: sortDefaultText))
            }
        }
        
        // 행사
        if !FilterDummy.data.tagMetaData.isEmpty {
            let eventDefaultText = "행사"
            categoryFilters.append(CategoryFilter(defaultText: eventDefaultText))
        }
        
        // 카테고리
        if !FilterDummy.data.categoryMetaData.isEmpty {
            let categoryDefaultText = "카테고리"
            categoryFilters.append(CategoryFilter(defaultText: categoryDefaultText))
        }
        
        // 상품 추천
        if !FilterDummy.data.eventMetaData.isEmpty {
            let eventDefaultText = "상품 추천"
            categoryFilters.append(CategoryFilter(defaultText: eventDefaultText))
        }
        return categoryFilters
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
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home.selected")
        )
        
        view.backgroundColor = .white
        viewHolder.containerScrollView.delegate = self
    }
    
    private func setupCollectionView() {
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.register(ConvenienceStoreCell.self)
        viewHolder.collectionView.register(CategoryFilterCell.self)
        viewHolder.collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let layout = TopCommonLayout()
            return layout.section(at: sectionIdentifier)
        }
    }
    
    private func setupProductCollectionView() {
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
    
    func didFinishPaging() {
        isPaging = false
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
            currentPage = indexPath.item
            viewHolder.productHomePageViewController.updatePage(to: currentPage)
        } else {
            if let productListViewController =  viewHolder.productHomePageViewController.viewControllers?.first as? ProductListViewController,
               let item = productListViewController.dataSource?.itemIdentifier(for: indexPath) {
                listener?.didSelect(with: item)
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
    func didLoadPageList(store: ConvenienceStore) {
        requestProducts(store: store)
    }
    
    func refreshByPull() {
        let store = ConvenienceStore.allCases[currentPage]
        requestProducts(store: store)
    }
    
    func didSelect(with brandProduct: ProductConvertable) {
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
