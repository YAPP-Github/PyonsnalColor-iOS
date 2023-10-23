//
//  StarRatingReviewRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol StarRatingReviewInteractable: Interactable, DetailReviewListener {
    var router: StarRatingReviewRouting? { get set }
    var listener: StarRatingReviewListener? { get set }
}

protocol StarRatingReviewViewControllable: ViewControllable {
}

final class StarRatingReviewRouter: ViewableRouter<StarRatingReviewInteractable, StarRatingReviewViewControllable>, StarRatingReviewRouting {
    
    private let detailReviewBuilder: DetailReviewBuildable
    private var detailReviewRouting: DetailReviewRouting?

    init(
        interactor: StarRatingReviewInteractable,
        viewController: StarRatingReviewViewControllable,
        detailReviewBuilder: DetailReviewBuildable
    ) {
        self.detailReviewBuilder = detailReviewBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachDetailReview(productDetail: ProductDetailEntity, score: Int) {
        guard detailReviewRouting == nil else { return }
        
        let detailReviewRouter = detailReviewBuilder.build(
            withListener: interactor,
            productDetail: productDetail,
            score: score
        )
        detailReviewRouting = detailReviewRouter
        attachChild(detailReviewRouter)
        viewController.pushViewController(detailReviewRouter.viewControllable, animated: true)
    }
    
    func detachDetailReview() {
        guard let detailReviewRouting else { return }
        
        viewController.popViewController(animated: true)
        self.detailReviewRouting = nil
        detachChild(detailReviewRouting)
    }
}
