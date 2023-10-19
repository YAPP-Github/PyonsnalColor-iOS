//
//  FavoritePageViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/10/16.
//

import UIKit

protocol FavoriteTabPageViewControllerDelegate: AnyObject {
    func updateSelectedTab(index: Int)
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction)
    func didTapProduct(product: any ProductConvertable)
    func loadMoreItems()
    func pullToRefresh()
    func loadProducts()
}

final class FavoritePageViewController: UIPageViewController {
    
    private var pageViewControllers = [FavoritePageTabViewController]()
    var currentIndex: Int = 0
    weak var pageDelegate: FavoriteTabPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewControllers()
    }
    
    private func setPageViewControllers() {
        FavoriteTab.allCases.forEach { _ in
            let viewController = FavoritePageTabViewController()
            viewController.delegate = self
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
    
    func updatePage(to index: Int) {
        let viewController = pageViewControllers[index]
        let direction: UIPageViewController.NavigationDirection = self.currentIndex <= index ? .forward : .reverse
        self.currentIndex = index
        
        setViewControllers([viewController], direction: direction, animated: true)
    }
    
    func updateProducts(to index: Int, with products: [any ProductConvertable]?) {
        self.pageViewControllers[index].update(with: products)
    }
}

extension FavoritePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers,
              let viewController = viewControllers.first as? FavoritePageTabViewController,
              let index = pageViewControllers.firstIndex(of: viewController) else {
            return
        }
        
        currentIndex = index
        pageDelegate?.updateSelectedTab(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? FavoritePageTabViewController {
            guard let index = pageViewControllers.firstIndex(of: viewController) else { return nil }
            let beforeIndex = index - 1
            if beforeIndex >= 0, beforeIndex < pageViewControllers.count {
                return pageViewControllers[beforeIndex]
            }
                
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController =  viewController as? FavoritePageTabViewController {
            guard let index = pageViewControllers.firstIndex(of: viewController) else { return nil }
            let afterIndex = index + 1
            if afterIndex >= 0, afterIndex < pageViewControllers.count {
                return pageViewControllers[afterIndex]
            }
        }
        return nil
    }
}

extension FavoritePageViewController: FavoritePageTabViewControllerDelegate {
    func loadProducts() {
        pageDelegate?.loadProducts()
    }
    
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction) {
        pageDelegate?.didTapFavoriteButton(product: product, action: action)
    }
    
    func didTapProduct(product: any ProductConvertable) {
        pageDelegate?.didTapProduct(product: product)
    }
    
    func loadMoreItems() {
        pageDelegate?.loadMoreItems()
    }
    
    func pullToRefresh() {
        pageDelegate?.pullToRefresh()
    }
}
