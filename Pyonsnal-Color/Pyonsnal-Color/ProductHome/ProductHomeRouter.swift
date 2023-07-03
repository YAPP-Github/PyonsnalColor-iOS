//
//  ProductHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeInteractable: Interactable {
    var router: ProductHomeRouting? { get set }
    var listener: ProductHomeListener? { get set }
}

protocol ProductHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductHomeRouter: ViewableRouter<ProductHomeInteractable, ProductHomeViewControllable>, ProductHomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProductHomeInteractable, viewController: ProductHomeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
