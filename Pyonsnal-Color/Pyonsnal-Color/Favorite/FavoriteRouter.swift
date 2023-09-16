//
//  FavoriteRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs

protocol FavoriteInteractable: Interactable {
    var router: FavoriteRouting? { get set }
    var listener: FavoriteListener? { get set }
}

protocol FavoriteViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FavoriteRouter: ViewableRouter<FavoriteInteractable, FavoriteViewControllable>, FavoriteRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FavoriteInteractable, viewController: FavoriteViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
