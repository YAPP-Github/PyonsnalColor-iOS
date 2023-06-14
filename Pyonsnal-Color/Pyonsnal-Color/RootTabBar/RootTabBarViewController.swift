//
//  RootTabBarViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol RootTabBarPresentableListener: AnyObject {
}

final class RootTabBarViewController:
    UITabBarController,
    RootTabBarPresentable,
    RootTabBarViewControllable {

    //MARK: - Property
    weak var listener: RootTabBarPresentableListener?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupTabBar()
    }
    
    //MARK: - Internal Method
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
    
    //MARK: - Private Method
    private func setupTabBar() {
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 16
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.applyShadow(color: .black, alpha: 0.25, width: 0, height: 4, blur: 4)
    }
}
