//
//  DetailReviewRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import ModernRIBs

protocol DetailReviewInteractable: Interactable {
    var router: DetailReviewRouting? { get set }
    var listener: DetailReviewListener? { get set }
}

protocol DetailReviewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class DetailReviewRouter: ViewableRouter<DetailReviewInteractable, DetailReviewViewControllable>, DetailReviewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: DetailReviewInteractable, viewController: DetailReviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
