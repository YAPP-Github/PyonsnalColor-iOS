//
//  StarRatingReviewRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol StarRatingReviewInteractable: Interactable {
    var router: StarRatingReviewRouting? { get set }
    var listener: StarRatingReviewListener? { get set }
}

protocol StarRatingReviewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class StarRatingReviewRouter: ViewableRouter<StarRatingReviewInteractable, StarRatingReviewViewControllable>, StarRatingReviewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: StarRatingReviewInteractable, viewController: StarRatingReviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
