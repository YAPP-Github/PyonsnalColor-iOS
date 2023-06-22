//
//  ConvenienceStorePageViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

final class ConvenienceStorePageViewController: UIPageViewController {
    
    //MARK: - Property
    private var productListViewControllers: [ProductListViewController] = []
    var currentViewController: ProductListViewController? {
        didSet {
            //TODO: 페이지 동기화 코드
        }
    }
    
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
        
        if let firstViewController = productListViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
            currentViewController = firstViewController
        }
    }
}

//MARK: - UIPageViewControllerDataSource
extension ConvenienceStorePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let productListViewController = viewController as? ProductListViewController,
              let index = productListViewControllers.firstIndex(of: productListViewController),
              index - 1 >= 0
        else {
            return nil
        }
        
        currentViewController = productListViewControllers[index - 1]
        return currentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
