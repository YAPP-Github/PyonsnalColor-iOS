//
//  ProductHomePageViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

protocol ProductHomePageViewControllerDelegate: AnyObject {
    func didFinishPageTransition(index: Int)
    func updateSelectedStoreCell(index: Int)
    func didChangeStore(to store: ConvenienceStore, filterList: [String])
    func didSelect(with brandProduct: ProductConvertable)
    
    func deleteFilterItem(with filter: FilterItemEntity, isSelected: Bool)
    func refreshFilterButton()
    func didFinishUpdateSnapshot()
    func didAppearProductList()
}

final class ProductHomePageViewController: UIPageViewController {
    
    // MARK: - Property
    weak var scrollDelegate: ScrollDelegate?
    weak var pagingDelegate: ProductHomePageViewControllerDelegate?
    var productListViewControllers: [UIViewController] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateChildViewControllers()
        configureViewController()
    }
    
    // MARK: - Private Method
    private func generateChildViewControllers() {
        let curationViewController = ProductCurationViewController()
        curationViewController.delegate = self
        productListViewControllers.append(curationViewController)
        
        ConvenienceStore.allCases.filter({ $0 != .all }).forEach {
            let childViewController = ProductListViewController(convenienceStore: $0)
            childViewController.scrollDelegate = self
            childViewController.listDelegate = self
            childViewController.delegate = self
            productListViewControllers.append(childViewController)
        }
    }
    
    func setFilterStateManager(with filterDataEntity: FilterDataEntity) {
        productListViewControllers.forEach { listViewController in
            if let viewController = listViewController as? ProductListViewController {
                viewController.setFilterStateManager(with: filterDataEntity)
            }
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .gray100
        view.translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        
        if let firstViewController = productListViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
        }
    }
    
    func updatePage(to page: Int) {
        guard let viewController = viewControllers?.first,
              let currentIndex = productListViewControllers.firstIndex(of: viewController)
        else {
            return
        }

        let isForward = currentIndex < page
        let direction: UIPageViewController.NavigationDirection = isForward ? .forward : .reverse
        setViewControllers(
            [productListViewControllers[page]],
            direction: direction,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UIPageViewControllerDataSource
extension ProductHomePageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = productListViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else {
            return nil
        }
        
        let beforeIndex = index - 1
        return productListViewControllers[beforeIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = productListViewControllers.firstIndex(of: viewController),
              index + 1 < productListViewControllers.count
        else {
            return nil
        }

        let nextIndex = index + 1
        return productListViewControllers[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension ProductHomePageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers,
              let viewController = viewControllers.first,
              let index = productListViewControllers.firstIndex(of: viewController)
        else {
            return
        }
        
        pagingDelegate?.didFinishPageTransition(index: index)
    }
}

// MARK: - ScrollDelegate
extension ProductHomePageViewController: ScrollDelegate {
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

// MARK: - ProductListDelegate
extension ProductHomePageViewController: ProductListDelegate {
    func didLoadPageList(store: ConvenienceStore) {
        pagingDelegate?.didChangeStore(to: store, filterList: [])
    }
    
    func refreshByPull(with filterList: [String]) {
        guard let viewController = viewControllers?.first,
              let index = productListViewControllers.firstIndex(of: viewController)
        else {
            return
        }
        
        pagingDelegate?.didChangeStore(to: ConvenienceStore.allCases[index], filterList: filterList)
    }
    
    func didSelect(with product: ProductConvertable?) {
        guard let product else { return }
        pagingDelegate?.didSelect(with: product)
    }
    
    func updateFilterState(with filter: FilterItemEntity, isSelected: Bool) {
        pagingDelegate?.deleteFilterItem(with: filter, isSelected: isSelected)
    }
    
    func refreshFilterButton() {
        pagingDelegate?.refreshFilterButton()
    }
    
    func didAppearProductList() {
        pagingDelegate?.didAppearProductList()
    }
    
    func didFinishUpdateSnapshot() {
        pagingDelegate?.didFinishUpdateSnapshot()
    }
}
