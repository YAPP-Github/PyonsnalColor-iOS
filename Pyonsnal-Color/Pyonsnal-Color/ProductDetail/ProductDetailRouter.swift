//
//  ProductDetailRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs

protocol ProductDetailInteractable: Interactable, StarRatingReviewListener {
    var router: ProductDetailRouting? { get set }
    var listener: ProductDetailListener? { get set }
}

protocol ProductDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductDetailRouter: ViewableRouter<ProductDetailInteractable, ProductDetailViewControllable>, ProductDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    private let starRatingReviewBuilder: StarRatingReviewBuildable
    private var starRatingReviewRouting: StarRatingReviewRouting?
    
    init(
        interactor: ProductDetailInteractable,
        viewController: ProductDetailViewControllable,
        starRatingReviewBuilder: StarRatingReviewBuildable
    ) {
        self.starRatingReviewBuilder = starRatingReviewBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachStarRatingReview(with productDetail: ProductDetailEntity) {
        guard starRatingReviewRouting == nil else { return }
        
        let starRatingReviewRouter = starRatingReviewBuilder.build(
            withListener: interactor,
            productDetail: productDetail
        )
        starRatingReviewRouting = starRatingReviewRouter
        attachChild(starRatingReviewRouter)
        viewController.pushViewController(starRatingReviewRouter.viewControllable, animated: true)
    }
    
    func detachStarRatingReview() {
        guard let starRatingReviewRouting else { return }
        
        viewController.popViewController(animated: true)
        self.starRatingReviewRouting = nil
        detachChild(starRatingReviewRouting)
    }
}
