//
//  RIBs+.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/02.
//

import UIKit
import ModernRIBs

final class NavigationControllable: ViewControllable {
    
    var uiviewController: UIViewController { self.navigationController }
    let navigationController: UINavigationController
    
    init(root: ViewControllable) {
        let navigationController = UINavigationController(rootViewController: root.uiviewController)
        navigationController.isNavigationBarHidden = true
        
        self.navigationController = navigationController
    }
    
}

extension ViewControllable {
    
    func pushViewController(_ viewControllable: ViewControllable, animated: Bool) {
        if let navigationController = uiviewController as? UINavigationController {
            navigationController.pushViewController(
                viewControllable.uiviewController,
                animated: animated
            )
        } else {
            uiviewController.navigationController?.pushViewController(
                viewControllable.uiviewController,
                animated: animated
            )
        }
    }
    
    func popViewController(animated: Bool) {
        if let navigationController = uiviewController as? UINavigationController {
            navigationController.popViewController(animated: animated)
        } else {
            uiviewController.navigationController?.popViewController(animated: animated)
        }
    }
}
