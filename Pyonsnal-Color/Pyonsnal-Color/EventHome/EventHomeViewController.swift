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
    func didLoadEventHome()
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore)
    func didTapSearchButton()
    func didTapProductCell()
    func didChangeStore(to store: ConvenienceStore)
    func didScrollToNextPage(store: ConvenienceStore)
    func didSelect(with brandProduct: ProductConvertable)
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
    
    enum SectionType: Hashable {
        case convenienceStore
        case filter
    }
    
    enum ItemType: Hashable {
        case convenienceStore(storeName: String)
        case filter(filterItem: CategoryFilter)
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    weak var listener: EventHomePresentableListener?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    private var dataSource: DataSource?
    private var innerScrollLastOffsetY: CGFloat = 0
    private let convenienceStores: [String] = CommonConstants.convenienceStore
    private var initIndex: Int = 0
    private var isPaging: Bool = false
    
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
        makeSnapshot()
        configureCollectionView()
        setPageViewController()
        setScrollView()
        configureUI()
        listener?.didLoadEventHome()
    }
    
    // MARK: - Private method
    private func configureNavigationView() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func configureDatasource() {
        dataSource = DataSource(collectionView: viewHolder.collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .convenienceStore(let storeName):
                let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(title: storeName)
                if indexPath.row == self.initIndex { // 초기 상태 selected
                    self.setSelectedConvenienceStoreCell(with: indexPath)
                }
                return cell
            case .filter(let filterItem):
                let cell: CategoryFilterCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(with: filterItem)
                return cell
            }
            
        }
    }
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        // append store
        snapshot.appendSections([.convenienceStore])
        let items = convenienceStores.map { storeName in
            return ItemType.convenienceStore(storeName: storeName)
        }
        snapshot.appendItems(items, toSection: .convenienceStore)
        
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
    
    private func configureCollectionView() {
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.register(ConvenienceStoreCell.self)
        viewHolder.collectionView.register(CategoryFilterCell.self)
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
            image: UIImage(named: ImageAssetKind.event.rawValue),
            selectedImage: UIImage(named: ImageAssetKind.eventSelected.rawValue)
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
        if let storeIndex = ConvenienceStore.allCases.firstIndex(of: store) {
            let tabViewController = viewHolder.pageViewController.pageViewControllers[storeIndex]
            tabViewController.applyEventProductsSnapshot(with: products)
        }
    }
    
    func update(with products: [EventProductEntity], banners: [EventBannerEntity], at store: ConvenienceStore) {
        if let storeIndex = ConvenienceStore.allCases.firstIndex(of: store) {
            let tabViewController = viewHolder.pageViewController.pageViewControllers[storeIndex]
            tabViewController.applyEventBannerProducts(with: banners, products: products)
        }
    }
    
    func didFinishPaging() {
        isPaging = false
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
                let height = ConvenienceStoreCell.Constant.Size.height + CategoryFilterCell.Size.height
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
    
    func didTapProductItemCell() {
        listener?.didTapProductCell()
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        listener?.didChangeStore(to: store)
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
            setSelectedConvenienceStoreCell(with: indexPath)
            viewHolder.pageViewController.updatePage(indexPath.row)
        }
    }
}

extension EventHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(title: convenienceStores[indexPath.row])
        let width = cell.getWidth()
        return CGSize(width: width,
                      height: ConvenienceStoreCell.Constant.Size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // device에 따라 dynamic interspacing 대응
        let cellConstant = ConvenienceStoreCell.Constant.Size.self
        let cellSizes = convenienceStores.reduce(CGFloat(0), { partialResult, title in
            let label = UILabel(frame: .zero)
            label.text = title
            label.font = cellConstant.font
            label.sizeToFit()
            return partialResult + label.bounds.width + cellConstant.padding.left * 2
        })
        let result = (collectionView.bounds.width - cellSizes) / CGFloat(convenienceStores.count - 1)
        
        return floor(result * 10000) / 10000
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
