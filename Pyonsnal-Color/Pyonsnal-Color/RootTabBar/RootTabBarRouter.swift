//
//  RootTabBarRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol RootTabBarInteractable:
    Interactable,
    ProductHomeListener,
    EventHomeListener,
    ProfileHomeListener {
    var router: RootTabBarRouting? { get set }
    var listener: RootTabBarListener? { get set }
}

protocol RootTabBarViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class RootTabBarRouter:
    ViewableRouter<RootTabBarInteractable,
    RootTabBarViewControllable>,
    RootTabBarRouting {
    
    private let productHomeBuilder: ProductHomeBuildable
    private var productHome: ViewableRouting?
    
    private let eventHomeBuilder: EventHomeBuildable
    private var eventHome: ViewableRouting?
    
    private let profileHomeBuilder: ProfileHomeBuildable
    private var profilHome: ViewableRouting?
    
    init(
        interactor: RootTabBarInteractable,
        viewController: RootTabBarViewControllable,
        productHomeBuilder: ProductHomeBuildable,
        eventHomeBuilder: EventHomeBuildable,
        profileHomeBuilder: ProfileHomeBuildable
    ) {
        self.productHomeBuilder = productHomeBuilder
        self.eventHomeBuilder = eventHomeBuilder
        self.profileHomeBuilder = profileHomeBuilder
        super.init(interactor: interactor, viewController: viewController)
        
        interactor.router = self
    }
    
    func attachTabs() {
        let productHome = productHomeBuilder.build(withListener: interactor)
        let eventHome = eventHomeBuilder.build(withListener: interactor)
        let profilHome = profileHomeBuilder.build(withListener: interactor)
        
        attachChild(productHome)
        attachChild(eventHome)
        attachChild(profilHome)
        
        let viewControllers: [ViewControllable] = [
            productHome.viewControllable,
            eventHome.viewControllable,
            profilHome.viewControllable
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
