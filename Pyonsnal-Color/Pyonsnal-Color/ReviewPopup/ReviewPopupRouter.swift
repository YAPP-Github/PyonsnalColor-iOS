//
//  ReviewPopupRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol ReviewPopupInteractable: Interactable {
    var router: ReviewPopupRouting? { get set }
    var listener: ReviewPopupListener? { get set }
}

protocol ReviewPopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ReviewPopupRouter: ViewableRouter<ReviewPopupInteractable, ReviewPopupViewControllable>, ReviewPopupRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ReviewPopupInteractable, viewController: ReviewPopupViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
