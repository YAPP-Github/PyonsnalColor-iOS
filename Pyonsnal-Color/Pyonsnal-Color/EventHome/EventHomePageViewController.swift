//
//  PersonalPageViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/15.
//

import UIKit

protocol EventHomePageViewControllerDelegate: AnyObject {
    func updateSelectedStoreCell(index: Int)
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore)
    func didChangeStore(to store: ConvenienceStore)
    func didSelect(with brandProduct: ProductConvertable)
    
    func deleteFilterItem(with filter: FilterItemEntity, isSelected: Bool)
    func refreshFilterButton()
    func didFinishUpdateSnapshot()
}

final class EventHomePageViewController: UIPageViewController {
    
    // MARK: - Private property
    private(set) var pageViewControllers = [EventHomeTabViewController]()
    private var currentIndex: Int = 0
    
    weak var pageDelegate: EventHomePageViewControllerDelegate?
    weak var scrollDelegate: ScrollDelegate?

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewControllers()
    }
    
    // MARK: - Private Method
    private func setPageViewControllers() {
        view.backgroundColor = .gray100
        for store in ConvenienceStore.allCases {
            if store == .all { continue }
            let viewController = EventHomeTabViewController(convenienceStore: store)
            viewController.scrollDelegate = self
            viewController.delegate = self
            viewController.listDelegate = self
            pageViewControllers.append(viewController)
        }
        
        self.delegate = self
        self.dataSource = self
        if let firstViewController = pageViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true)
        }
    }
    
    func setFilterStateManager(with filterDataEntity: FilterDataEntity) {
        // 이벤트 탭에서는 상품 추천 filterType 제외
        let eventFilterEntity = filterDataEntity.data.filter { $0.filterType != .recommend }
        let eventFilterDataEntity = FilterDataEntity(data: eventFilterEntity)
        pageViewControllers.forEach { tabViewController in
            tabViewController.setFilterStateManager(with: eventFilterDataEntity)
        }
    }
    
    func updatePage(_ index: Int) {
        let viewController = pageViewControllers[index]
        let direction: UIPageViewController.NavigationDirection = currentIndex <= index ? .forward : .reverse
        currentIndex = index
        
        setViewControllers([viewController],
                           direction: direction,
                           animated: true)
    }
    
}

extension EventHomePageViewController: UIPageViewControllerDelegate,
                                       UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers,
              let viewController = viewControllers.first as? EventHomeTabViewController,
              let index = pageViewControllers.firstIndex(of: viewController) else {
            return
        }
        
        currentIndex = index
        pageDelegate?.updateSelectedStoreCell(index: index)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        if let viewController = viewController as? EventHomeTabViewController {
            guard let index = pageViewControllers.firstIndex(of: viewController) else { return nil }
            let beforeIndex = index - 1
            if beforeIndex >= 0, beforeIndex < pageViewControllers.count {
                return pageViewControllers[beforeIndex]
            }
        }
        return nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        if let viewController =  viewController as? EventHomeTabViewController {
            guard let index = pageViewControllers.firstIndex(of: viewController) else { return nil }
            let afterIndex = index + 1
            if afterIndex >= 0, afterIndex < pageViewControllers.count {
                return pageViewControllers[afterIndex]
            }
        }
        return nil
        
    }
}

// MARK: - ScrollDelegate
extension EventHomePageViewController: ScrollDelegate {
    func didScroll(scrollView: UIScrollView) {
        scrollDelegate?.didScroll(scrollView: scrollView)
    }
    
    func willBeginDragging(scrollView: UIScrollView) {
        scrollDelegate?.willBeginDragging(scrollView: scrollView)
    }
    
    func didEndDragging(scrollView: UIScrollView) {
        scrollDelegate?.didEndDragging(scrollView: scrollView)
    }
}

// MARK: - EventHomeTabViewControllerDelegate
extension EventHomePageViewController: EventHomeTabViewControllerDelegate {
    
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore) {
        pageDelegate?.didTapEventBannerCell(with: imageURL, store: store)
    }
    
    func didTapFilterDeleteButton(with filter: FilterItemEntity) {
        pageDelegate?.deleteFilterItem(with: filter, isSelected: false)
    }
}

extension EventHomePageViewController: ProductListDelegate {
    
    func didLoadPageList(store: ConvenienceStore) {
        pageDelegate?.didChangeStore(to: store)
    }
    
    func refreshByPull() {
        pageDelegate?.didChangeStore(to: ConvenienceStore.allCases[currentIndex])
    }
    
    func didSelect(with brandProduct: ProductConvertable?) {
        guard let brandProduct else { return }
        pageDelegate?.didSelect(with: brandProduct)
    }
    
    func updateFilterState(with filter: FilterItemEntity, isSelected: Bool) {
        pageDelegate?.deleteFilterItem(with: filter, isSelected: isSelected)
    }
    
    func refreshFilterButton() {
        pageDelegate?.refreshFilterButton()
    }
    
    func didAppearProductList() {
    }
    
    func didFinishUpdateSnapshot() {
        pageDelegate?.didFinishUpdateSnapshot()
    }
}
