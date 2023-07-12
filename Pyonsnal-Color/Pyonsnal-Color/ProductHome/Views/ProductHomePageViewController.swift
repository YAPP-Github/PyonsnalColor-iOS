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
}

final class ProductHomePageViewController: UIPageViewController {
    
    //MARK: - Property
    weak var pagingDelegate: ProductHomePageViewControllerDelegate?
    var productListViewControllers: [ProductListViewController] = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateChildViewControllers()
        configureViewController()
    }
    
    //MARK: - Private Method
    private func generateChildViewControllers() {
        ConvenienceStore.allCases.forEach {
            let childViewController = ProductListViewController(convenienceStore: $0)
            productListViewControllers.append(childViewController)
        }
    }
    
    private func configureViewController() {
        view.translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        
        if let firstViewController = productListViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
        }
    }
    
    func updatePage(to page: Int) {
        guard let viewController = viewControllers?.first as? ProductListViewController,
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

//MARK: - UIPageViewControllerDataSource
extension ProductHomePageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let productListViewController = viewController as? ProductListViewController,
              let index = productListViewControllers.firstIndex(of: productListViewController),
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
        guard let productListViewController = viewController as? ProductListViewController,
              let index = productListViewControllers.firstIndex(of: productListViewController),
              index + 1 < productListViewControllers.count
        else {
            return nil
        }

        let nextIndex = index + 1
        return productListViewControllers[nextIndex]
    }
}

//MARK: - UIPageViewControllerDelegate
extension ProductHomePageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers,
              let viewController = viewControllers.first as? ProductListViewController,
              let index = productListViewControllers.firstIndex(of: viewController)
        else {
            return
        }
        
        pagingDelegate?.didFinishPageTransition(index: index)
    }
}
