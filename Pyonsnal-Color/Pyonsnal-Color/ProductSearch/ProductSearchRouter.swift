//
//  ProductSearchRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs

protocol ProductSearchInteractable: Interactable {
    var router: ProductSearchRouting? { get set }
    var listener: ProductSearchListener? { get set }
}

protocol ProductSearchViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductSearchRouter: ViewableRouter<ProductSearchInteractable, ProductSearchViewControllable>, ProductSearchRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProductSearchInteractable, viewController: ProductSearchViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
