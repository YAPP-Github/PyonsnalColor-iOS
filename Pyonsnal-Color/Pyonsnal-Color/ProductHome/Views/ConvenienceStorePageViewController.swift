//
//  ConvenienceStorePageViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

protocol ConvenienceStorePageViewControllerDelegate: NSObject {
    func didFinishPageTransition(index: Int)
}

final class ConvenienceStorePageViewController: UIPageViewController {
    
    //MARK: - Property
    weak var pagingDelegate: ConvenienceStorePageViewControllerDelegate?
    var productListViewControllers: [ProductListViewController] = []
    var currentViewController: ProductListViewController?
    
    //MARK: - Initializer
    init(
        pageCount: Int,
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation)
        
        generateChildViewControllers(pageCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    //MARK: - Private Method
    private func generateChildViewControllers(_ count: Int) {
        Array(1...count).forEach { _ in
            let childViewController = ProductListViewController()
            productListViewControllers.append(childViewController)
        }
    }
    
    private func configureViewController() {
        view.translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        
        if let firstViewController = productListViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
            currentViewController = firstViewController
        }
    }
}

//MARK: - UIPageViewControllerDataSource
extension ConvenienceStorePageViewController: UIPageViewControllerDataSource {
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
        
        currentViewController = productListViewControllers[index - 1]
        return currentViewController
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
        
        currentViewController = productListViewControllers[index + 1]
        return currentViewController
    }
}

//MARK: - UIPageViewControllerDelegate
extension ConvenienceStorePageViewController: UIPageViewControllerDelegate {
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
