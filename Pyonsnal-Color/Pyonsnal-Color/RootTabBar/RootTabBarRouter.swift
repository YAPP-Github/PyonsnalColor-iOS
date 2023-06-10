//
//  RootTabBarRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol RootTabBarInteractable: Interactable {
    var router: RootTabBarRouting? { get set }
    var listener: RootTabBarListener? { get set }
}

protocol RootTabBarViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootTabBarRouter: ViewableRouter<RootTabBarInteractable, RootTabBarViewControllable>, RootTabBarRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RootTabBarInteractable, viewController: RootTabBarViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

